#lang racket
(require ffi/unsafe
         "lib.rkt")

; XXX Add the types
(define-mpi-ref MPI_COMM_WORLD ompi_mpi_comm_world)
(define-mpi-ref MPI_CHAR ompi_mpi_char)

(define-cstruct _MPI_Status
  ([MPI_SOURCE _int]
   [MPI_TAG _int]
   [MPI_ERROR _int]
   [_count _int]
   [_cancelled _int]))

(provide (all-defined-out))