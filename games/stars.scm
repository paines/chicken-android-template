(use sdl2 srfi-1 extras s48-modules)

(include "games/common.scm")

(define (make-star pos bad?) (cons bad? pos))
(define (star-pos star) (cdr star))
(define (star-bad? star) (car star))

(define (random-star)
  (let ((size (sdl-get-window-size w)))
    (make-star (v (random (v.x size)) (random (v.y size)))
               (if (< 5 (random 10)) #f #t))))

(define stars (map (lambda (x) (random-star)) (iota 100)))

(define (move-star! star v #!optional (respawn identity))
  (let ((s (star-pos star)))
    (let ((np (v+ v s))
          (size (sdl-get-window-size w)))

      (define bounded? (and (< (v.x np) (v.x size))
                            (< (v.y np) (v.y size))
                            (> (v.x np) 0)
                            (> (v.y np) 0)))

      (let ((np (if bounded? np (respawn np))))
        (set! (v.x s) (v.x np))
        (set! (v.y s) (v.y np))))))

;; wrap around screen
(define (wrap-star vect)
  (let ( (size (sdl-get-window-size w)))
    (v (wrap (v.x vect) (v.x size))
       (wrap (v.y vect) (v.y size)))))

(define (move-stars stars direction)
  (for-each (cut move-star! <> direction wrap-star) stars))

(define (draw-star s)
  (let ((C 80))
   (sdl-set-render-draw-color r
                              (if (star-bad? s) 255 C) C
                              (if (star-bad? s) C 255) C))
  (sdl-render-fill-rect r (make-sdl-rect (- (->fx (v.x (star-pos s))) 2)
                                         (- (->fx (v.y (star-pos s))) 2)
                                         5 5)))

(define (game-iteration)

  (sdl-set-render-draw-color r 0 0 30 0)
  (sdl-render-clear r)

  (for-each draw-star stars)
  (move-stars stars (v .3 0.7))

  (sdl-render-present r))
