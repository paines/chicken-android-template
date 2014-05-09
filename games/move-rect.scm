(use sdl2 s48-modules)

(include-relative "common.scm")

(define rect-pos (v 200 100))

(define ->fixnum (o inexact->exact round))

(define (draw-rect)
  (sdl-set-render-draw-color r 50 200 50 50)
  (sdl-render-fill-rect r (make-sdl-rect (v.x rect-pos)
                                         (v.y rect-pos)
                                         100 100)))


(define game-iteration
  ;; private holder for event
  (let ((e (make-sdl-event)))
    
    (lambda ()
      ;; inner event-loop
      (handle-input)
      
      (sdl-set-render-draw-color r 0 40 0 0)
      (sdl-render-clear r)

      ;; draw "web"
      (sdl-set-render-draw-color r 0 200 0 0)
      (define (l p1 p2)
        (sdl-render-draw-line r    (v.x p1) (v.y p1)    (v.x p2) (v.y p2)))

      (let* ((br (sdl-get-window-size w v))
             (tl (v* br (v 0 0)))
             (tr (v* br (v 0 1)))
             (bl (v* br (v 1 0))))
        (l tl (v+ rect-pos (v 0 0)))
        (l tr (v+ rect-pos (v 0 100)))
        (l bl (v+ rect-pos (v 100 0)))
        (l br (v+ rect-pos (v 100 100))))
      
      (draw-rect)
      (sdl-render-present r))))


