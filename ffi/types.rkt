#lang racket
(require ffi/unsafe)

; XXX Use cpointers
(define _MPI_Comm _pointer)
(define _MPI_Datatype _pointer)
(define _MPI_Comm? cpointer?)
(define _MPI_Datatype? cpointer?)

(define _int? exact-integer?)

(define-cstruct _MPI_Status
  ([MPI_SOURCE _int]
   [MPI_TAG _int]
   [MPI_ERROR _int]
   [_count _int]
   [_cancelled _int]))

; XXX make cstruct-out and defcstruct

(provide (all-defined-out))