(define-module (wayland server protocol wayland)
  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config))

(use-wayland-protocol (%wayland-protocol #:type server))
