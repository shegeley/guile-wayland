(define-module (tests syntax))

(define-syntax use-wayland-protocol*
  (lambda (x)
    (syntax-case x ()
      ((_ (xml-path a ...))
       #'(list (cond ((string? xml-path) "hello")
                     ((symbol? xml-path) 'world)
                     (else 10)) a
                     ...)))))

(use-wayland-protocol* ("looool" #:type 'server))
