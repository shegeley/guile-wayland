(define-module (wayland client protocol wayland)
  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config))

(use-wayland-protocol (%wayland-protocol #:type client))
