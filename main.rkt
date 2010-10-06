#lang racket
(require ffi/unsafe)

(define libmpi (ffi-lib "libmpi"))

(define-syntax-rule (define-mpi* name fname type)
  (define name 
    (get-ffi-obj 'fname libmpi type)))
(define-syntax-rule (define-mpi name type)
  (define-mpi* name name type))

;;;;;

; XXX OpenMPI only
(define-syntax-rule (define-openmpi-constant constant-id mpi-id)
  (begin (define mpi-id (ffi-obj-ref 'mpi-id libmpi))
         (define constant-id mpi-id)))

(define _MPI_Comm _pointer)
(define-openmpi-constant MPI_COMM_WORLD ompi_mpi_comm_world)

(define _MPI_Datatype _pointer)
(define-openmpi-constant MPI_CHAR ompi_mpi_char)

(define-cstruct _MPI_Status
  ([MPI_SOURCE _int]
   [MPI_TAG _int]
   [MPI_ERROR _int]
   [_count _int]
   [_cancelled _int]))

;;;;;;

(define (handle-errcode fun errcode)
  (unless (zero? errcode)
    (error fun "Non-zero return errcode: ~e" errcode)))

(define-mpi MPI_Init
  (_fun (v) ::
        [argc : _int = (vector-length v)]
        [argv : (_vector i _string) = v]
        -> [errcode : _int]
        -> (handle-errcode 'MPI_Init errcode)))

(define-mpi MPI_Finalize
  (_fun -> [errcode : _int]
        -> (handle-errcode 'MPI_Finalize errcode)))

(define-mpi MPI_Comm_size
  (_fun _MPI_Comm
        [size : (_ptr o _int)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Comm_size errcode)
                  size)))
(define-mpi MPI_Comm_rank
  (_fun _MPI_Comm
        [rank : (_ptr o _int)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Comm_rank errcode)
                  rank)))

(define MPI_MAX_PROCESSOR_NAME 256)
(define-mpi MPI_Get_processor_name
  (_fun [name : (_bytes o MPI_MAX_PROCESSOR_NAME)]
        [actual-len : (_ptr o _int)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Get_processor_name errcode)
                  (subbytes name 0 actual-len))))

(define-mpi MPI_Get_count
  (_fun [status : _MPI_Status-pointer]
        [datatype : _MPI_Datatype]
        [count : (_ptr o _int)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Get_count errcode)
                  count)))

(define-mpi* MPI_Send:CHAR MPI_Send
  (_fun [buf : _bytes]
        [count : _int = (bytes-length buf)]
        [datatype : _MPI_Datatype = MPI_CHAR]
        [dest : _int]
        [tag : _int]
        [comm : _MPI_Comm]
        -> [errcode : _int]
        -> (handle-errcode 'MPI_Send:CHAR errcode)))

(define-mpi* MPI_Recv:CHAR MPI_Recv
  (_fun (len src tag comm) ::
        [buf : (_bytes o len)]
        [len : _int]
        [datatype : _MPI_Datatype = MPI_CHAR]
        [src : _int]
        [tag : _int]
        [comm : _MPI_Comm]
        [status : (_ptr o _MPI_Status)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Recv:CHAR errcode)
                  (let ([actual (MPI_Get_count status MPI_CHAR)])
                    (subbytes buf 0 actual)))))

(provide (all-defined-out))