#lang at-exp racket
(require ffi/unsafe
         (prefix-in c: racket/contract)
         scribble/srcdoc)
(require/doc racket/base
             scribble/manual)

(define libmpi (ffi-lib "libmpi"))

(define-syntax-rule (define-mpi* (name fname)
                      type 
                      ([arg-name contract-e] ... return-contract)
                      desc)
  (begin
    (define name 
      (get-ffi-obj 'fname libmpi type))
    (provide/doc
     [proc-doc/names
      name (c:-> contract-e ... return-contract)
      (arg-name ...) desc])))
(define-syntax-rule (define-mpi name 
                      type
                      ([arg-name contract-e] ... return-contract))
  (define-mpi* (name name)
    type
    ([arg-name contract-e] ... return-contract)
    @{}))

(define-syntax-rule (define-mpi-ref constant-id mpi-id)
  (begin (define constant-id (ffi-obj-ref 'mpi-id libmpi))
         (provide/doc
          [thing-doc constant-id cpointer?
                     @{}])))

(define-syntax-rule (define-mpi-constant constant-id value ctc)
  (begin (define constant-id value)
         (provide/doc
          [thing-doc constant-id ctc
                     @{}])))

(provide define-mpi
         define-mpi*
         define-mpi-ref
         define-mpi-constant)