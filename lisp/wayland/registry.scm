(define-module (wayland registry)
  #:use-module (wayland util)
  #:use-module (wayland proxy)
  #:use-module (wayland interface)
  #:use-module (ice-9 format)
  #:use-module (oop goops)
  #:use-module (srfi srfi-9)
  #:use-module ((system foreign) #:select (null-pointer?
                                           bytevector->pointer
                                           make-pointer
                                           procedure->pointer
                                           pointer->procedure
                                           pointer->bytevector
                                           pointer->string
                                           string->pointer
                                           sizeof
                                           %null-pointer
                                           define-wrapped-pointer-type
                                           pointer-address
                                           void
                                           (int . ffi:int)
                                           (uint32 . ffi:uint32)
                                           (double . ffi:double)
                                           (size_t . ffi:size_t)
                                           (uintptr_t . ffi:uintptr_t)))
  #:use-module (bytestructure-class)
  #:use-module (bytestructures guile)
  #:export (WL_REGISTRY_BIND
            %wl-registry-interface
            wl-registry?
            wrap-wl-registry

            make-wl-registry-listener
            wl-registry-add-listener
            wl-registry-get-version
            wl-registry-get-user-data
            wl-registry-bind))

(define WL_REGISTRY_BIND 0)

(define-public %wl-registry-interface
  (wrap-wl-interface
   (wayland-server->pointer "wl_registry_interface")))

(define %wl-registry-struct (bs:unknow))
(define-bytestructure-class <wl-registry> (<wl-proxy>)
  %wl-registry-struct
  wrap-wl-registry unwrap-wl-registry wl-registry?)

(define %wl-registry-listener
  (bs:struct
   `((global ,(bs:pointer '*))
     (global-remove ,(bs:pointer '*)))))

(define-bytestructure-class <wl-registry-listener> ()
  %wl-registry-listener
  wrap-wl-registry-listener unwrap-wl-registry-listener wl-registry-listener?
  (global #:accessor .global)
  (global-remove #:accessor .global-remove))

(define (make-wl-registry-listener global global-remove)
  "global need registry "
  (let ((o (make <wl-registry-listener>)))
    (slot-set! o 'global (procedure->pointer
                          void
                          (lambda (data registry name interface version)
                            (global data

                                    (wrap-wl-registry registry)
                                    (make-pointer->string name)
                                    (pointer->string interface)
                                    version
                                    ))
                          (list '* '* ffi:uint32 '* ffi:uint32)))
    (slot-set! o 'global-remove (procedure->pointer
                                 void
                                 (lambda (data registry name)
                                   (global-remove

                                    data
                                    (wrap-wl-registry registry)
                                    (make-pointer->string name)))
                                 (list '*
                                       '* ffi:uint32)))
    o))

(define-method (wl-registry-add-listener (registry <wl-registry>) listener data)
  (wl-proxy-add-listener
   registry
   (if (wl-registry-listener? listener)
       (unwrap-wl-registry-listener listener)
       listener)
   data))
(define-method (wl-registry-add-listener (registry <wl-registry>) listener )
  (wl-registry-add-listener registry listener %null-pointer))

(define-method (wl-registry-get-version (registry <wl-registry>))
  (wl-proxy-get-version registry))
(define-method (wl-registry-get-user-data (registry <wl-registry>))
  (wl-proxy-get-user-data registry))

(define (wl-registry-bind registry name interface version)
  (wl-proxy-marshal-constructor-versioned
   registry WL_REGISTRY_BIND
   interface version

   name
   (.name interface)
   version
   %null-pointer))
