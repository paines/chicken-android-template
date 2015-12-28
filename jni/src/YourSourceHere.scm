
;; we need this to use SDL's main macro
(foreign-declare "#include <SDL.h>")
(foreign-declare "#include \"stdio2log.c\"")

;; start a thread which will read our stdout/stderr and forward to
;; logcat. this is pretty much a must-have since GLSL compile errors
;; etc end up on stderr usually.
((foreign-lambda void start_logger))

;; make (use sdl2) work properly (.so lib prefix path hack)
(include "./jni/chicken/find-extension.scm")

;; include your favorite program here
;;
;; you should be able to run these on your PC too, with csi -s
;; sdl2-main.scm for example.

;; (include "./games/move-rect.scm")
(include "./games/interstar-galactica.scm")

;; add a network REPL and loop forever
;;
;; using some other threads for game loop
;; using this thread for replloop
(use ports) ;; <-- workaround for nrepl bug
(use nrepl)
(nrepl 1234)
