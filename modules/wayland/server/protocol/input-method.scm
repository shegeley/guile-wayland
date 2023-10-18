(define-module (wayland server protocol input-method)
  #:use-module (wayland server protocol wayland)
  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config))

(eval-when (compile)
  (define input-method.xml
    (string-append %wayland-protocols-dir
                   "/input-method-unstable-v2.xml")))

(use-wayland-protocol (input-method.xml #:type server))
