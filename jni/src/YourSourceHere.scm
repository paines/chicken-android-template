
;; we need this to use SDL's main macro
(foreign-declare "#include <SDL.h>")
(use ports)


;; this has saved my butt many times:
(let ((o (let ((p (open-output-file "/sdcard/log")))
           (make-output-port (lambda (str) (display str p)
                                (flush-output p))
                             (lambda () (close-output-port p))))))
  (current-error-port o)
  (current-output-port o))

;; make (use sdl2) work properly (.so lib prefix path hack)
(include "./jni/chicken/find-extension.scm")

;; include your favorite program here
;;
;; you should be able to run these on your PC too, with csi -s
;; sdl2-main.scm for example.
(include "./games/move-rect.scm")

;; add a network REPL and loop forever
;;
;; using some other threads for game loop
;; using this thread for replloop
(use grepl)
(make-grepl 1234)
