#lang at-exp racket/base
(require racket/list
         parser-tools/yacc
         parser-tools/lex
         (prefix-in : parser-tools/lex-sre))

(define-tokens value-tokens (ID NUM))
(define-empty-tokens op-tokens (DEFINE ENUM COMMA LPAREN RPAREN LBRACE RBRACE STAR AMP EOF))

(define c-lex
  (lexer
   [(eof) (token-EOF)]
   [(:: "/*" (complement (:: any-string "*/" any-string)) "*/")
    (c-lex input-port)]
   ["#define" (token-DEFINE)]
   ["enum" (token-ENUM)]
   [#\, (token-COMMA)]
   [(:or #\tab #\space #\newline) (c-lex input-port)]
   [(:+ numeric #\-) (token-NUM (string->number lexeme))]
   [(:+ alphabetic numeric #\_) (token-ID (string->symbol lexeme))]
   [#\( (token-LPAREN)]
   [#\) (token-RPAREN)]
   [#\{ (token-LBRACE)]
   [#\} (token-RBRACE)]
   [#\* (token-STAR)]
   [#\& (token-AMP)]
   ))

(define c-parse
  (parser
   (start defs)
   (end EOF)
   (tokens value-tokens op-tokens)
   (error
    (lambda (tok-ok? tok-name tok-value)
      (if tok-ok?
          (error 'c-parser "Error at ~a(~v)" tok-name tok-value)
          (error 'c-parser "Invalid token at ~a(~v)" tok-name tok-value))))

   (grammar    
    [defs [() empty]
      [(def defs) (cons $1 $2)]]
    
    [def [(DEFINE ID expr) (def $2 $3)]
      [(ENUM LBRACE enum-body RBRACE) (enum $3)]]
    
    [enum-body [(ID) (list $1)]
               [(ID COMMA enum-body) (cons $1 $3)]]
    
    [expr [(NUM) $1]
          [(ID) (expr:alias $1)]
          [(LPAREN NUM RPAREN) $2]
          [(LPAREN AMP ID RPAREN) (expr:addr $3)]
          [(LPAREN LPAREN ID STAR RPAREN NUM RPAREN) (expr:ptr 1 $3 $6)]
          [(LPAREN LPAREN ID STAR STAR RPAREN NUM RPAREN) (expr:ptr 2 $3 $7)]
          [(LPAREN LPAREN ID STAR STAR STAR RPAREN NUM RPAREN) (expr:ptr 3 $3 $8)]])))

(struct def (id expr) #:transparent)
(struct enum (ids) #:transparent)
(struct expr:alias (id) #:transparent)
(struct expr:addr (id) #:transparent)
(struct expr:ptr (rank type num) #:transparent)
    
(define (parse-c-header-strs . strs)
  (define-values (in out) (make-pipe))
  (for ([s (in-list strs)]) (display s out))
  (close-output-port out)
  (c-parse (lambda () (c-lex in))))

(provide (all-defined-out))
