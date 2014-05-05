(use sdl2)

(begin
  (define w (sdl-create-window "hello world" 100 100 400 300 (+ SDL_WINDOW_RESIZABLE)))
  (define s (sdl-get-window-surface w))

  (print window: w surface: s)

  (define running? #t))

(begin
  (define v cons)
  (define v.x car)
  (define v.y cdr))

(define rect-pos (v 200 10))

(define ->fixnum (o inexact->exact round))

(define (draw-rect)
  (sdl-fill-rect s (make-sdl-rect (v.x rect-pos)
                                  (v.y rect-pos)
                                  50 50)
                 (sdl-map-rgba (sdl-surface-pixel-format s)
                               255 0 0 0)))

(define (normal->screen vect window)
  (let ((size ;(sdl-get-window-size window v)
         (v 2000 1000)
         ))
   (v (->fixnum (* (v.x size) (v.x vect)))
      (->fixnum (* (v.y size) (v.y vect))))))

;; (normal->screen (v 0.3 1) w)

(define (game-iteration)
  (let ((e (make-sdl-event)))
    
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

    (draw-rect)
    (sdl-update-window-surface w)))

(print "NOT HERE!!!!")
(define thread
  (thread-start!
   (lambda () (let loop ()
           (game-iteration)
           (thread-yield!)
           (if running? (loop))))))

;; (thread-state thread)
;; (thread-terminate! thread)
(print)
