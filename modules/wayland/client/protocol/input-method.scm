(define-module (wayland client protocol input-method)
  #:use-module (wayland client protocol wayland)
  #:use-module ((wayland util)
                #:select (xml))

  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config))

(eval-when (compile)
  (define input-method.xml
    (xml "input-method-unstable-v2")))

(use-wayland-protocol (input-method.xml #:type client))
