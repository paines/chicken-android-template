(use sdl2 s48-modules)
(include "games/stars.scm")


;; return a new star (when star is off screen / dies)
(define (respawn-pos vect)
  (let ((size (sdl-get-window-size w)))
    (v (random (v.x size)) (v.y size))))

(define (respawn-pos! vect)
  (let ((np (respawn-pos vect)))
    (set! (v.x vect) (v.x np))
    (set! (v.y vect) (v.y np))))

(define *pos* (v 0 0))
(define (move-stars stars direction)
  (for-each (cut move-star! <> direction respawn-pos)
            stars)
  (set! *pos* (v+ *pos* direction)))

(define cursor (/ (v.x (sdl-get-window-size w)) 2))

(define (cursor-rect cursor)
  (make-sdl-rect (- cursor 10) (+ 100)
                 50 10))

;; (cursor-rect cursor)

;; list of stars that collide with cursor
(define (collisions stars)
  (filter (lambda (star)
            (sdl-rect-intersects? (cursor-rect cursor) (star-pos star)))
          stars))

(define *collisions* 0)
(define (collision! star)
  (set! *collisions* (+ (if (star-bad? star) 1 -1) *collisions*))
  (respawn-pos! (star-pos star)))

(define (score)
  (- (* (v.y *pos*) 0.01) (* *collisions* *collisions*)))

(define (make-score-rect)
  (let* ((ymargin 10)
         (size (sdl-get-window-size w))
         (height (->fx (score))))
    (make-sdl-rect 10 (/ (v.y size) 2)
                   10 height)))

(define (collision-detection)
  (for-each collision! (collisions stars)))

(define (draw-cursor cursor)
  (sdl-set-render-draw-color r 255 255 255 255)
  (sdl-render-fill-rect r (cursor-rect cursor)))

(define (draw-score)
  (let ((sr (make-score-rect)))
    (sdl-set-render-draw-color r 255 255 255 255)
    (sdl-render-fill-rect r sr)

    (sdl-set-render-draw-color r 255 100 100 0)
    (sdl-render-fill-rect r sr)))

(define (game-iteration)

  ;; drawing
  (sdl-set-render-draw-color r 30 30 20 0)
  (sdl-render-clear r)

  (sdl-set-render-draw-color r 255 0 0 0)
  (for-each draw-star stars)
  (draw-cursor cursor)
  (draw-score)

  ;; "physics"
  (move-stars stars (v 0 -2))
  (collision-detection)

  (sdl-render-present r))

(define-handler SDL_MOUSEMOTION
  (lambda (e)
    (set! cursor (sdl-event-x e))))
