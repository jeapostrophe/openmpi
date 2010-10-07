#lang racket
(require ffi/unsafe)

; XXX Use cpointers
(define _MPI_Comm _pointer)
(define _MPI_Datatype _pointer)
(define _MPI_Comm? cpointer?)
(define _MPI_Datatype? cpointer?)

(define _int? exact-integer?)

(provide (all-defined-out))