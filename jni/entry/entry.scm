;; we need this to use SDL's main macro
(foreign-declare "#include <SDL.h>")
(foreign-declare "#include \"stdio2log.c\"")

;; start a thread which will read our stdout/stderr and forward to
;; logcat. this is pretty much a must-have since GLSL compile errors
;; etc end up on stderr usually.
((foreign-lambda void start_logger))

;; must come before any (use ...) declarations!
(include "./jni/chicken/find-extension.scm")

;; replace with your favorite program here

(use s48-modules)
(include-relative "../../games/example.scm")

;; it may be good practice to have your game start a srfi-18 thread,
;; do it's game loop there, and then return. this way, you can just do
;;
;; csi example.scm
;;
;; and the same file should run on your desktop too, and you get the
;; repl in the background. can be handy! let's follow the same
;; convention here, but using nrepl instead:

(use ports) ;; <-- workaround for nrepl bug
(use nrepl)
;; add a network REPL and loop forever
(nrepl 1234)


;; if we reach here, the app will exit
