#lang scribble/doc
@(require scribble/manual
          scribble/basic
          scribble/extract
          (for-label (except-in ffi/unsafe ->)
                     (only-in racket/contract contract?)
                     racket/base
                     mpi))

@title[#:tag "top"]{MPI}
@author[(author+email "Jay McCarthy" "jay@racket-lang.org")]

@defmodule[mpi]

This package provides a binding for the @link["http://www.open-mpi.org/"]{OpenMPI} implementation of the @link["http://en.wikipedia.org/wiki/Message_Passing_Interface"]{MPI} API.

This documentation does not describe meaning of API calls; it only describes their Racket calling conventions. For details on API semantics, refer to the documentation at the @link["http://www.open-mpi.org/doc/"]{OpenMPI site}.

@local-table-of-contents[]

@section[#:tag "constants"]{Constants}
@defmodule[mpi/ffi/constants]
@include-extracted["ffi/constants.rkt"]

@section[#:tag "types"]{Basic Types}
@defmodule[mpi/ffi/types]
@defthing[_int? contract?]{Identical to @racket[exact-integer?].}
@defthing[_MPI_Datatype? contract?]{Identical to @racket[cpointer?].}
@defthing[_MPI_Comm? contract?]{Identical to @racket[cpointer?].}

@defstruct*[MPI_Status ([MPI_SOURCE _int?]
                       [MPI_TAG _int?]
                       [MPI_ERROR _int?]
                       [_count _int?]
                       [_cancelled _int?])]{
 A structure representing MPI statuses.                                            
}

@defthing[MPI_Status? contract?]{Identical to @racket[cpointer?].}

@section[#:tag "mpi"]{API}
@defmodule[mpi/ffi/mpi]

@include-extracted["ffi/mpi.rkt"]
