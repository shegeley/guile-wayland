(define-module (foreign-toplevel interface)
 #:use-module (wayland client protocol wayland)
 #:use-module (wayland client display)

 #:use-module (wayland interface)
 #:use-module (wayland client proxy)

 #:use-module (bytestructure-class)
 #:use-module (wayland scanner)
 #:use-module (wayland config))

(parameterize ((guile-wayland-protocol-path
                (cons (dirname (current-filename))
                 (guile-wayland-protocol-path))))
 (eval `(use-wayland-protocol ("wlr-foreign-toplevel-management-unstable-v1.xml" #:type client))
  (current-module)))
