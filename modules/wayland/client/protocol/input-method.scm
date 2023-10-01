(define-module (wayland client protocol input-method)
  #:use-module (wayland client protocol wayland)
  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config))

(eval-when (compile)
  (define input-method.xml
    (string-append %wayland-protocols-dir "/wayland-protocols/unstable/input-method/input-method-unstable-v1.xml")))

(use-wayland-protocol (input-method.xml #:type client))
