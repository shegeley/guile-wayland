(define-module (wayland client protocol xdg-shell)
  #:use-module (wayland client protocol wayland)
  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config))

(eval-when (compile)

  (define xdg-shell.xml (string-append %wayland-protocols-dir "/wayland-protocols/stable/xdg-shell/xdg-shell.xml")))

(use-wayland-protocol (xdg-shell.xml #:type 'client))
