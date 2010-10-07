#lang at-exp racket/base
(require ffi/unsafe
         (except-in racket/contract ->)
         (file "lib.rkt")
         (file "types.rkt")
         (file "constants.rkt")
         scribble/srcdoc)
(require/doc racket/base
             scribble/manual)

; XXX Can we do better errors?
(define (handle-errcode fun errcode)
  (unless (zero? errcode)
    (error fun "Non-zero return errcode: ~e" errcode)))

(define-mpi MPI_Init
  (_fun (v) ::
        [argc : _int = (vector-length v)]
        [argv : (_vector i _string) = v]
        -> [errcode : _int]
        -> (handle-errcode 'MPI_Init errcode))
  ([args (vectorof string?)]
   void))

(define-mpi MPI_Finalize
  (_fun -> [errcode : _int]
        -> (handle-errcode 'MPI_Finalize errcode))
  (void))

(define-mpi MPI_Comm_size
  (_fun _MPI_Comm
        [size : (_ptr o _int)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Comm_size errcode)
                  size))
  ([comm _MPI_Comm?]
   _int?))
(define-mpi MPI_Comm_rank
  (_fun _MPI_Comm
        [rank : (_ptr o _int)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Comm_rank errcode)
                  rank))
  ([comm _MPI_Comm?]
   _int?))
; XXX Return string
(define-mpi MPI_Get_processor_name
  (_fun [name : (_bytes o MPI_MAX_PROCESSOR_NAME)]
        [actual-len : (_ptr o _int)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Get_processor_name errcode)
                  (subbytes name 0 actual-len)))
  (bytes?))

(define-mpi MPI_Get_count
  (_fun [status : _MPI_Status-pointer]
        [datatype : _MPI_Datatype]
        [count : (_ptr o _int)]
        -> [errcode : _int]
        -> (begin (handle-errcode 'MPI_Get_count errcode)
                  count))
  ([status MPI_Status?]
   [datatype _MPI_Datatype?]
   _int?))

; XXX Have bytes, string, list/vector of char, single char functions
; XXX Use a single macro for both (all)
(define-mpi* (MPI_Send:CHAR MPI_Send)
  (_fun [buf : _bytes]
        [count : _int = (bytes-length buf)]
        [datatype : _MPI_Datatype = MPI_CHAR]
        [dest : _int]
        [tag : _int]
        [comm : _MPI_Comm]
        -> [errcode : _int]
        -> (handle-errcode 'MPI_Send:CHAR errcode))
  ([buf bytes?]
   [dest _int?]
   [tag _int?]
   [comm _MPI_Comm?]
   void)
  @{A wrapper around MPI_Send for the MPI_CHAR datatype using bytes.})

(define-mpi* (MPI_Recv:CHAR MPI_Recv)
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
                    (subbytes buf 0 actual))))
  ([maximum-len _int?]
   [src _int?]
   [tag _int?]
   [comm _MPI_Comm?]
   bytes?)
  @{A wrapper around MPI_Recv for the MPI_CHAR datatype using bytes.})
