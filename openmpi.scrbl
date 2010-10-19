#lang scribble/doc
@(require scribble/manual
          scribble/basic
          scribble/extract
          unstable/scribble
          (for-label (except-in ffi/unsafe ->)
                     racket
                     (file "main.rkt")))

@title[#:tag "top"]{OpenMPI}
@author[(author+email "Jay McCarthy" "jay@racket-lang.org")]

@defmodule/this-package[]

This package provides a binding for the @link["http://www.open-mpi.org/"]{OpenMPI} implementation of the @link["http://en.wikipedia.org/wiki/Message_Passing_Interface"]{MPI} API.

This documentation does not describe meaning of API calls; it only describes their Racket calling conventions. For details on API semantics, refer to the documentation at the @link["http://www.open-mpi.org/doc/"]{OpenMPI site}.

@local-table-of-contents[]

@section[#:tag "constants"]{Constants}
@defmodule/this-package[ffi/constants]
@include-extracted[(file "ffi/constants.rkt")]

@section[#:tag "mpi"]{API}
@defmodule/this-package[ffi/mpi]
@include-extracted[(file "ffi/mpi.rkt")]
