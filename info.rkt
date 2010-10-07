#lang setup/infotab
(define name "OpenMPI")
(define blurb
  (list "An FFI for OpenMPI"))
(define scribblings '(["openmpi.scrbl" (multi-page)]))
(define categories '(devtools))
(define primary-file "main.rkt")
(define compile-omit-paths '("examples"))
(define release-notes 
  (list
   '(ul (li "Initial release"))))
(define repositories '("4.x"))
