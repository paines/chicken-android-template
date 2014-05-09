(use sdl2)

;; window sizes seem to be ignored on mobile devices
(define w (sdl-create-window "hello world" 20 30 400 300 0))
(define r (sdl-create-renderer w -1 (+ SDL_RENDERER_ACCELERATED)))

(define running? #t)


(begin
  ;; a tiny vector API
  (define v cons)
  (define v.x car)
  (define v.y cdr)
  (define (make-v-proc proc)
    (lambda (a b) (v (proc (v.x a) (v.x b))
                (proc (v.y a) (v.y b)))))
  (define v+ (make-v-proc +))
  (define v* (make-v-proc *)))

(begin ;; keep confined

  ;; TODO: wrap around negive numers too?
  (define (wrap x size) (- x (* size (floor (/ x size)))))

  (begin
    (assert (= 1 (wrap 1 10)))
    (assert (= 1 (wrap 21 10)))))



;; vect is (v 0..1 .  0..1)
(define (normal->screen vect window)
  (let ((size (sdl-get-window-size window v)))
   (v (->fixnum (* (v.x size) (v.x vect)))
      (->fixnum (* (v.y size) (v.y vect))))))

(define (->screen vect window)
  (if (flonum? (v.x vect))
      (normal->screen vect window)
      vect))

;; ==================== intersection util ====================
(define (sdl-rect-intersects? rect point)
  (and (>= (v.x point) (sdl-rect-x rect))
       (>= (v.y point) (sdl-rect-y rect))
       (<= (v.x point) (+ (sdl-rect-x rect)
                          (sdl-rect-w rect)))
       (<= (v.y point) (+ (sdl-rect-y rect)
                          (sdl-rect-h rect)))))

(let ((r (make-sdl-rect 10 100 5 10)))
  (assert (eq? #f (sdl-rect-intersects? r (v 0 0))))
  (assert (eq? #t (sdl-rect-intersects? r (v 10 100))))
  (assert (eq? #t (sdl-rect-intersects? r (v 15 110))))
  (assert (eq? #f (sdl-rect-intersects? r (v 16 111))))

  (assert (eq? #f (sdl-rect-intersects? r (v 10 111))))
  (assert (eq? #f (sdl-rect-intersects? r (v 16 110)))))

;; ==================== various utils ====================
(define (->fx x) (inexact->exact (truncate x)))



;; (normal->screen (v 0.5 0.5) w)

;; you should implement this
(define (game-iteration) (void))

(define *input-handlers* `())
(define (set-input-handler! event-types proc)
  (define (add! et) (set! *input-handlers*
                          (alist-update et proc *input-handlers*)))
  (if (list? event-types)
      (for-each add! event-types)
      (add! event-types)))

(define input-handler
  (let ((e (make-sdl-event)))
    (lambda ()
      (let loop ()
        (if (sdl-poll-event! e)
            (let ((et (sdl-event-type e)))
              (cond ((alist-ref et *input-handlers*) => (lambda (proc) (proc e)))
                    (else (print "no handler for event " e)))
              (loop)))))))


;; (thread-state thread)
(begin
  (handle-exceptions e (print ";; note: thread does not exist") (thread-terminate! thread))
  (define thread
    (thread-start! (lambda ()
                     (let loop ()
                       (input-handler)
                c       (game-iteration)
                       ;;(thread-sleep! 0.01)
                       ;;(thread-yield!) ;; <-- let grepl thread run
                       (if running? (loop)))))))


(define-syntax define-handler
  (syntax-rules ()
    ((_ types proc) (set-input-handler! types proc))))

(define-handler
  (list SDL_FINGERDOWN SDL_FINGERUP
        SDL_FINGERMOTION SDL_MOUSEMOTION)
  (lambda (event)
    (print event)))
