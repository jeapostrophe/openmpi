#lang racket
(require "openmpi.rkt")

; XXX Get them all
(define MPI_MAX_PROCESSOR_NAME 256)

(provide (all-defined-out)
         (all-from-out "openmpi.rkt"))