#lang racket/base
(require mpi)

(eprintf "Arguments: ~v\n" (current-command-line-arguments))
(MPI_Init (current-command-line-arguments))

(define numprocs (MPI_Comm_size MPI_COMM_WORLD))
(define rank (MPI_Comm_rank MPI_COMM_WORLD))
(define processor_name (MPI_Get_processor_name))

(if (zero? rank)
    (let ()
      (printf "[~a/~a ~a]: I am the master\n" rank numprocs processor_name)
      (for ([i (in-range 1 numprocs)])
        (MPI_Send:CHAR (string->bytes/utf-8 (format "Hello ~a..." i)) i 0 MPI_COMM_WORLD))
      (for ([i (in-range 1 numprocs)])
        (printf "[~a/~a ~a]: Received: ~a\n" rank numprocs processor_name
                (MPI_Recv:CHAR 128 i 0 MPI_COMM_WORLD))))
    (let ()
      (printf "[~a/~a ~a]: I am the servant\n" rank numprocs processor_name)
      (define input (MPI_Recv:CHAR 128 0 0 MPI_COMM_WORLD))
      (printf "[~a/~a ~a]: Received: ~a\n" rank numprocs processor_name input)
      (MPI_Send:CHAR (string->bytes/utf-8 (format "Processor ~a reporting!" rank))
                     0 0 MPI_COMM_WORLD)))

(MPI_Finalize)
