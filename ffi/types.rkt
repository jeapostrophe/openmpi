#lang racket
(require ffi/unsafe)

(define _MPI_Comm _pointer)
(define _MPI_Datatype _pointer)

(provide (all-defined-out))