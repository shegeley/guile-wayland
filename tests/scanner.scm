(define-module (tests scanner)
  #:use-module (bytestructure-class)
  #:use-module (wayland scanner)
  #:use-module (wayland config)
  ;; NOTE: maybe including whole guix as dependency is a bad idea
  ;; should be a way to move (guix build utils) "outside"
  #:use-module (guix build utils))

(define (xml? filename)
  (string-suffix-ci? ".xml" filename))

(define protocols
  (find-files %wayland-protocols-dir
              (lambda (filename _) (xml? filename))))

(test-begin "Scanning all the protocols")

(map
 (lambda (p)
   (use-wayland-protocol p #:type 'client)
   (use-wayland-protocol p #:type 'server))
 protocols)

(test-end)
