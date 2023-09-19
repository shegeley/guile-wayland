(define-module (wayland client protocol text-input)
  #:use-module (wayland client protocol wayland)
  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config))

(eval-when (compile)
  (define text-input.xml
    (string-append %wayland-protocols-dir "/wayland-protocols/unstable/text-input/text-input-unstable-v3.xml")))

(use-wayland-protocol (text-input.xml #:type client))
