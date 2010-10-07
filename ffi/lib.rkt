#lang racket
(require ffi/unsafe)

(define libmpi (ffi-lib "libmpi"))

(define-syntax-rule (define-mpi* name fname type)
  (begin
    (define name 
      (get-ffi-obj 'fname libmpi type))
    (provide name)))
(define-syntax-rule (define-mpi name type)
  (define-mpi* name name type))

(define-syntax-rule (define-mpi-ref constant-id mpi-id)
  (begin (define mpi-id (ffi-obj-ref 'mpi-id libmpi))
         (define constant-id mpi-id)
         (provide constant-id)))

(provide define-mpi
         define-mpi*
         define-mpi-ref)