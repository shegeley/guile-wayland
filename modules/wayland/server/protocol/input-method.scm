(define-module (wayland server protocol input-method)
  #:use-module (wayland server protocol wayland)
  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config)
  #:use-module ((wayland util)
                #:select (xml)))

(eval-when (compile)
  (define input-method.xml
    (xml "input-method-unstable-v2")))

(use-wayland-protocol (input-method.xml #:type server))
