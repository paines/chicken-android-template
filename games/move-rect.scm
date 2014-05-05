(use sdl2)

(define w (sdl-create-window "hello world" 20 30 400 300 0))
(define r (sdl-create-renderer w -1 (+ SDL_RENDERER_ACCELERATED)))

(define running? #t)

(begin
  (define v cons)
  (define v.x car)
  (define v.y cdr))

(define rect-pos (v 200 100))

(define ->fixnum (o inexact->exact round))

(define (draw-rect)
  (sdl-set-render-draw-color r 50 200 50 50)
  (sdl-render-fill-rect r (make-sdl-rect (v.x rect-pos)
                                         (v.y rect-pos)
                                         100 100)))

;; vect is (v 0..1 .  0..1)
(define (normal->screen vect window)
  (let ((size (sdl-get-window-size window v)))
   (v (->fixnum (* (v.x size) (v.x vect)))
      (->fixnum (* (v.y size) (v.y vect))))))

(define game-iteration
  ;; private holder for event
  (let ((e (make-sdl-event)))
    
    (lambda ()
      ;; inner event-loop
      (let loop ()
        (if (sdl-poll-event! e)
            (let ((et (sdl-event-type e)))
              ;; (print "incoming event " e)
              (cond ((= et SDL_QUIT) (set! running? #f))
                    ((= et SDL_FINGERMOTION)
                     (set! rect-pos (normal->screen (v (sdl-event-x e)
                                                       (sdl-event-y e))
                                                    w))))
              (loop))))
      
      (sdl-set-render-draw-color r 0 40 0 0)
      (sdl-render-clear r)

      (draw-rect)
      (sdl-render-present r))))

(define thread
  (thread-start! (lambda ()
                   (let loop ()
                     (game-iteration)
                     (thread-yield!) ;; <-- let grepl thread run
                     (if running? (loop))))))

;; (thread-state thread)
;; (thread-terminate! thread)
