(define-module (foreign-toplevel wayland)
  #:use-module (wayland client display)
  #:use-module (wayland client protocol wayland)
  #:use-module (wayland interface)
  #:use-module (wayland client proxy)
  #:use-module (wayland scanner)

  #:use-module (foreign-toplevel interface)
  #:use-module (foreign-toplevel wayland wrappers)
  #:use-module (foreign-toplevel utils)

  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-64)

  #:use-module (ice-9 match)
  #:use-module (ice-9 format)
  #:use-module (ice-9 threads)

  #:use-module (oop goops))

;; globals
(define %display        #f)
(define %registry       #f)
(define %log            '())
(define %raw-interfaces '())
(define %interfaces     '())

;; log
(define* (get-events #:optional (interface #f))
 (let [(f (lambda (e) (false-if-exception (eq? (listener interface) (first e)))))]
  (filter f %log)))

(define %event-handler ;; args := (event-listener-class event-name event-args)
 (lambda args (set! %log (cons args %log))))

;; wrappers
(define* (make-listener* class #:optional (args '()))
  (make-listener class args #:primary-handler %event-handler))

(define (add-listener* wayland-interface)
 (add-listener wayland-interface (make-listener* (listener wayland-interface))))

(define (try-add-listener* wayland-interface)
 (false-if-exception (add-listener* wayland-interface)))

(define (handle-interface wayland-interface)
 (try-add-listener* wayland-interface)
 (catch-interface! wayland-interface))

;; %interfaces
(define (get-interface class)
  (find (lambda (x) (eq? (class-of x) class)) %interfaces))

(define i get-interface)

(define (catch-interface! interface)
  (set! %interfaces (cons interface %interfaces)))

;; registry
(define (registry:try-init-interface data registry name interface version)
  "Not all interfaces can init. Only those which was loaded with (use-wayland-protocol ...) in their module and required in the current module"
  (set! %raw-interfaces (cons (list data registry name interface version) %raw-interfaces))
  (false-if-exception (registry:init-interface data registry name interface version)))

(define (registry:global-handler data registry name interface version)
 "registry's #:global handler"
 (let* [(interface (registry:try-init-interface data registry name interface version))]
   (when interface (handle-interface interface))))

(define registry-listener
  (make-listener* <wl-registry-listener> (list #:global registry:global-handler)))

;; main event loop
(define (connect)
 (set! %display (wl-display-connect))
 (unless %display (error (format (current-error-port) "Unable to connect to wayland compositor~%"))))

(define (roundtrip) (wl-display-roundtrip %display))

(define (get-registry)
  (set! %registry (wl-display-get-registry %display))
  (wl-display-sync %display)
  (add-listener %registry registry-listener)
  (roundtrip))

(define (spin) (while #t (wl-display-dispatch %display)))

(define (start!)
  (connect)
  (get-registry)
  ;; (spin) ;; NOTE: breaks here
  )

;; control flow
(define thread #f)

(define (run!)
  (if thread
      (restart!)
      (set! thread (call-with-new-thread start!))))

(define (exit!)
 (when (and thread (not (thread-exited? thread)))
  (cancel-thread         thread)
  (set!         thread   #f)
  (set!    %interfaces   '())
  (set!           %log   '())
  (wl-display-flush      %display)
  (wl-display-disconnect %display)))

(define (restart!) (exit!) (run!))

(run!)

(test-begin "foreign-toplevel-management")
(test-assert "foreign-toplevel-management: [wrapping the interface]"
 (find (lambda (x) (eq? <zwlr-foreign-toplevel-manager-v1> (class-of x)))
  %interfaces))
(test-error "foreign-toplevel-management: [roundtrip] try to listen some events, error 139 SIGSEGV"
 'error-signal (begin (run!) (roundtrip)))
(test-error "foreign-toplevel-management: [dispatch] try to listen some events, error 139 SIGSEGV"
 'error-signal (begin (run!) (spin!)))
(test-end)
