#lang at-exp racket
(require (except-in ffi/unsafe ->)
         scribble/srcdoc
         (file "lib.rkt"))
(require/doc racket/base
             (for-label (except-in racket/contract ->)
                        (except-in ffi/unsafe ->))
             scribble/manual)

(require (for-syntax unstable/syntax
                     racket/list
                     racket/match
                     (file "parsec.rkt")))
(define-syntax (parse-c-header stx)
  (syntax-case stx ()
    [(_ str ...)
     (quasisyntax/loc stx
       (begin #,@(map (match-lambda
                        [(def id (? number? n))
                         #`(define-mpi-constant #,(datum->syntax stx id) #,n number?)]
                        [(def id (expr:ptr rank type 0))
                         #`(define-mpi-constant #,(datum->syntax stx id) #f cpointer?)]
                        [(def id (expr:ptr rank type 1))
                         #`(define-mpi-constant #,(datum->syntax stx id) (cast 1 _intptr _pointer) cpointer?)]
                        [(def id (expr:alias other-id))
                         #`(define-mpi-constant #,(datum->syntax stx id) #,(datum->syntax stx other-id) number?)]
                        [(enum ids)
                         #`(begin #,@(for/list ([id (in-list ids)]
                                                [i (in-naturals)])
                                       #`(define-mpi-constant #,(datum->syntax stx id) #,i number?)))]
                        [(def id (expr:addr sym))
                         #`(define-mpi-ref #,(datum->syntax stx id) #,sym)])
                      (apply parse-c-header-strs (syntax-map syntax->datum #'(str ...))))))]))

@parse-c-header{
/* ompi/include/mpi.h.  Generated from mpi.h.in by configure.  */
/*
 * Copyright (c) 2004-2005 The Trustees of Indiana University and Indiana
 *                         University Research and Technology
 *                         Corporation.  All rights reserved.
 * Copyright (c) 2004-2006 The University of Tennessee and The University
 *                         of Tennessee Research Foundation.  All rights
 *                         reserved.
 * Copyright (c) 2004-2005 High Performance Computing Center Stuttgart, 
 *                         University of Stuttgart.  All rights reserved.
 * Copyright (c) 2004-2005 The Regents of the University of California.
 *                         All rights reserved.
 * Copyright (c) 2007-2008 Cisco Systems, Inc.  All rights reserved.
 * $COPYRIGHT$
 * 
 * Additional copyrights may follow
 * 
 * $HEADER$
 */

/*
 * MPI version
 */
#define MPI_VERSION 2
#define MPI_SUBVERSION 0

/*
 * Miscellaneous constants
 */
#define MPI_ANY_SOURCE         -1      /* match any source rank */
#define MPI_PROC_NULL          -2      /* rank of null process */
#define MPI_ROOT               -4
#define MPI_ANY_TAG            -1      /* match any message tag */
#define MPI_MAX_PROCESSOR_NAME 256     /* max proc. name length */
#define MPI_MAX_ERROR_STRING   256     /* max error message length */
#define MPI_MAX_OBJECT_NAME    64      /* max object name length */
#define MPI_UNDEFINED          -32766  /* undefined stuff */
#define MPI_CART               1       /* cartesian topology */
#define MPI_GRAPH              2       /* graph topology */
#define MPI_KEYVAL_INVALID     -1      /* invalid key value */

/*
 * More constants
 */
#define MPI_BOTTOM               ((void *) 0)    /* base reference address */
#define MPI_IN_PLACE             ((void *) 1)    /* in place buffer */
#define MPI_BSEND_OVERHEAD       128     /* size of bsend header + ptr */
#define MPI_MAX_INFO_KEY         36      /* max info key length */
#define MPI_MAX_INFO_VAL         256     /* max info value length */
#define MPI_ARGV_NULL            ((char **) 0)   /* NULL argument vector */
#define MPI_ARGVS_NULL           ((char ***) 0)  /* NULL argument vectors */
#define MPI_ERRCODES_IGNORE      ((int *) 0)    /* don't return error codes */
#define MPI_MAX_PORT_NAME        36      /* max port name length */
#define MPI_MAX_NAME_LEN         MPI_MAX_PORT_NAME /* max port name length */
#define MPI_ORDER_C              0       /* C row major order */
#define MPI_ORDER_FORTRAN        1       /* Fortran column major order */
#define MPI_DISTRIBUTE_BLOCK     0       /* block distribution */
#define MPI_DISTRIBUTE_CYCLIC    1       /* cyclic distribution */
#define MPI_DISTRIBUTE_NONE      2       /* not distributed */
#define MPI_DISTRIBUTE_DFLT_DARG (-1)    /* default distribution arg */

/*
 * Since these values are arbitrary to Open MPI, we might as well make
 * them the same as ROMIO for ease of mapping.  These values taken
 * from ROMIO's mpio.h file.
 */
#define MPI_MODE_CREATE              1  /* ADIO_CREATE */ 
#define MPI_MODE_RDONLY              2  /* ADIO_RDONLY */
#define MPI_MODE_WRONLY              4  /* ADIO_WRONLY  */
#define MPI_MODE_RDWR                8  /* ADIO_RDWR  */
#define MPI_MODE_DELETE_ON_CLOSE    16  /* ADIO_DELETE_ON_CLOSE */
#define MPI_MODE_UNIQUE_OPEN        32  /* ADIO_UNIQUE_OPEN */
#define MPI_MODE_EXCL               64  /* ADIO_EXCL */
#define MPI_MODE_APPEND            128  /* ADIO_APPEND */
#define MPI_MODE_SEQUENTIAL        256  /* ADIO_SEQUENTIAL */

#define MPI_DISPLACEMENT_CURRENT   -54278278

#define MPI_SEEK_SET            600
#define MPI_SEEK_CUR            602
#define MPI_SEEK_END            604

#define MPI_MAX_DATAREP_STRING  128

/*
 * MPI-2 One-Sided Communications asserts
 */
#define MPI_MODE_NOCHECK             1
#define MPI_MODE_NOPRECEDE           2
#define MPI_MODE_NOPUT               4
#define MPI_MODE_NOSTORE             8
#define MPI_MODE_NOSUCCEED          16

#define MPI_LOCK_EXCLUSIVE           1
#define MPI_LOCK_SHARED              2


/*
 * Predefined attribute keyvals
 *
 * DO NOT CHANGE THE ORDER WITHOUT ALSO CHANGING THE ORDER IN
 * src/attribute/attribute_predefined.c and mpif.h.in.
 */
enum {
    /* MPI-1 */
    MPI_TAG_UB,
    MPI_HOST,
    MPI_IO,
    MPI_WTIME_IS_GLOBAL,

    /* MPI-2 */
    MPI_APPNUM,
    MPI_LASTUSEDCODE,
    MPI_UNIVERSE_SIZE,
    MPI_WIN_BASE,
    MPI_WIN_SIZE,
    MPI_WIN_DISP_UNIT,

    /* Even though these four are IMPI attributes, they need to be there
       for all MPI jobs */
    IMPI_CLIENT_SIZE,
    IMPI_CLIENT_COLOR,
    IMPI_HOST_SIZE,
    IMPI_HOST_COLOR
}

/*
 * Error classes and codes
 * Do not change the values of these without also modifying mpif.h.in.
 */
#define MPI_SUCCESS                   0  
#define MPI_ERR_BUFFER                1
#define MPI_ERR_COUNT                 2
#define MPI_ERR_TYPE                  3
#define MPI_ERR_TAG                   4
#define MPI_ERR_COMM                  5
#define MPI_ERR_RANK                  6
#define MPI_ERR_REQUEST               7
#define MPI_ERR_ROOT                  8
#define MPI_ERR_GROUP                 9
#define MPI_ERR_OP                    10
#define MPI_ERR_TOPOLOGY              11
#define MPI_ERR_DIMS                  12
#define MPI_ERR_ARG                   13
#define MPI_ERR_UNKNOWN               14
#define MPI_ERR_TRUNCATE              15
#define MPI_ERR_OTHER                 16
#define MPI_ERR_INTERN                17
#define MPI_ERR_IN_STATUS             18
#define MPI_ERR_PENDING               19
#define MPI_ERR_ACCESS                20
#define MPI_ERR_AMODE                 21
#define MPI_ERR_ASSERT                22
#define MPI_ERR_BAD_FILE              23
#define MPI_ERR_BASE                  24
#define MPI_ERR_CONVERSION            25
#define MPI_ERR_DISP                  26
#define MPI_ERR_DUP_DATAREP           27
#define MPI_ERR_FILE_EXISTS           28
#define MPI_ERR_FILE_IN_USE           29
#define MPI_ERR_FILE                  30
#define MPI_ERR_INFO_KEY              31
#define MPI_ERR_INFO_NOKEY            32
#define MPI_ERR_INFO_VALUE            33
#define MPI_ERR_INFO                  34
#define MPI_ERR_IO                    35
#define MPI_ERR_KEYVAL                36
#define MPI_ERR_LOCKTYPE              37
#define MPI_ERR_NAME                  38
#define MPI_ERR_NO_MEM                39
#define MPI_ERR_NOT_SAME              40
#define MPI_ERR_NO_SPACE              41
#define MPI_ERR_NO_SUCH_FILE          42
#define MPI_ERR_PORT                  43
#define MPI_ERR_QUOTA                 44
#define MPI_ERR_READ_ONLY             45
#define MPI_ERR_RMA_CONFLICT          46
#define MPI_ERR_RMA_SYNC              47
#define MPI_ERR_SERVICE               48
#define MPI_ERR_SIZE                  49
#define MPI_ERR_SPAWN                 50
#define MPI_ERR_UNSUPPORTED_DATAREP   51
#define MPI_ERR_UNSUPPORTED_OPERATION 52
#define MPI_ERR_WIN                   53
#define MPI_ERR_LASTCODE              54

#define MPI_ERR_SYSRESOURCE          -2


/*
 * Comparison results.  Don't change the order of these, the group
 * comparison functions rely on it.
 * Do not change the order of these without also modifying mpif.h.in.
 */
enum {
  MPI_IDENT,
  MPI_CONGRUENT,
  MPI_SIMILAR,
  MPI_UNEQUAL
}

/*
 * MPI_Init_thread constants
 * Do not change the order of these without also modifying mpif.h.in.
 */
enum {
  MPI_THREAD_SINGLE,
  MPI_THREAD_FUNNELED,
  MPI_THREAD_SERIALIZED,
  MPI_THREAD_MULTIPLE
}

/*
 * Datatype combiners.
 * Do not change the order of these without also modifying mpif.h.in.
 */
enum {
  MPI_COMBINER_NAMED,
  MPI_COMBINER_DUP,
  MPI_COMBINER_CONTIGUOUS,
  MPI_COMBINER_VECTOR,
  MPI_COMBINER_HVECTOR_INTEGER,
  MPI_COMBINER_HVECTOR,
  MPI_COMBINER_INDEXED,
  MPI_COMBINER_HINDEXED_INTEGER,
  MPI_COMBINER_HINDEXED,
  MPI_COMBINER_INDEXED_BLOCK,
  MPI_COMBINER_STRUCT_INTEGER,
  MPI_COMBINER_STRUCT,
  MPI_COMBINER_SUBARRAY,
  MPI_COMBINER_DARRAY,
  MPI_COMBINER_F90_REAL,
  MPI_COMBINER_F90_COMPLEX,
  MPI_COMBINER_F90_INTEGER,
  MPI_COMBINER_RESIZED
}

/*
 * NULL handles
 */
#define MPI_GROUP_NULL (&ompi_mpi_group_null)
#define MPI_COMM_NULL (&ompi_mpi_comm_null)
#define MPI_REQUEST_NULL (&ompi_request_null)
#define MPI_OP_NULL (&ompi_mpi_op_null)
#define MPI_ERRHANDLER_NULL (&ompi_mpi_errhandler_null)
#define MPI_INFO_NULL (&ompi_mpi_info_null)
#define MPI_WIN_NULL (&ompi_mpi_win_null)
#define MPI_FILE_NULL (&ompi_mpi_file_null)

#define MPI_STATUS_IGNORE ((MPI_Status *) 0)
#define MPI_STATUSES_IGNORE ((MPI_Status *) 0)

/*
 * MPI predefined handles
 */
#define MPI_COMM_WORLD (&ompi_mpi_comm_world)
#define MPI_COMM_SELF (&ompi_mpi_comm_self)

#define MPI_GROUP_EMPTY (&ompi_mpi_group_empty)

#define MPI_MAX (&ompi_mpi_op_max)
#define MPI_MIN (&ompi_mpi_op_min)
#define MPI_SUM (&ompi_mpi_op_sum)
#define MPI_PROD (&ompi_mpi_op_prod)
#define MPI_LAND (&ompi_mpi_op_land)
#define MPI_BAND (&ompi_mpi_op_band)
#define MPI_LOR (&ompi_mpi_op_lor)
#define MPI_BOR (&ompi_mpi_op_bor)
#define MPI_LXOR (&ompi_mpi_op_lxor)
#define MPI_BXOR (&ompi_mpi_op_bxor)
#define MPI_MAXLOC (&ompi_mpi_op_maxloc)
#define MPI_MINLOC (&ompi_mpi_op_minloc)
#define MPI_REPLACE (&ompi_mpi_op_replace)

/* C datatypes */
#define MPI_DATATYPE_NULL (&ompi_mpi_datatype_null)
#define MPI_BYTE (&ompi_mpi_byte)
#define MPI_PACKED (&ompi_mpi_packed)
#define MPI_CHAR (&ompi_mpi_char)
#define MPI_SHORT (&ompi_mpi_short)
#define MPI_INT (&ompi_mpi_int)
#define MPI_LONG (&ompi_mpi_long)
#define MPI_FLOAT (&ompi_mpi_float)
#define MPI_DOUBLE (&ompi_mpi_double)
#define MPI_LONG_DOUBLE (&ompi_mpi_long_double)
#define MPI_UNSIGNED_CHAR (&ompi_mpi_unsigned_char)
#define MPI_SIGNED_CHAR (&ompi_mpi_signed_char)
#define MPI_UNSIGNED_SHORT (&ompi_mpi_unsigned_short)
#define MPI_UNSIGNED_LONG (&ompi_mpi_unsigned_long)
#define MPI_UNSIGNED (&ompi_mpi_unsigned)
#define MPI_FLOAT_INT (&ompi_mpi_float_int)
#define MPI_DOUBLE_INT (&ompi_mpi_double_int)
#define MPI_LONG_DOUBLE_INT (&ompi_mpi_longdbl_int)
#define MPI_LONG_INT (&ompi_mpi_long_int)
#define MPI_SHORT_INT (&ompi_mpi_short_int)
#define MPI_2INT (&ompi_mpi_2int)
#define MPI_UB (&ompi_mpi_ub)
#define MPI_LB (&ompi_mpi_lb)
#define MPI_WCHAR (&ompi_mpi_wchar)
#define MPI_LONG_LONG_INT (&ompi_mpi_long_long_int)
#define MPI_LONG_LONG (&ompi_mpi_long_long_int)
#define MPI_UNSIGNED_LONG_LONG (&ompi_mpi_unsigned_long_long)
#define MPI_2COMPLEX (&ompi_mpi_2cplex)
#define MPI_2DOUBLE_COMPLEX (&ompi_mpi_2dblcplex)

#define MPI_ERRORS_ARE_FATAL (&ompi_mpi_errors_are_fatal)
#define MPI_ERRORS_RETURN (&ompi_mpi_errors_return)

/* Typeclass definition for MPI_Type_match_size */
#define MPI_TYPECLASS_INTEGER    1
#define MPI_TYPECLASS_REAL       2
#define MPI_TYPECLASS_COMPLEX    3
}