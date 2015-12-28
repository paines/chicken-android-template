
PROJECT_ROOT = ${PWD}
PACKAGE_NAME     := $(shell csi -s ./jni/chicken/find-package.scm AndroidManifest.xml)
CHICKEN_BIN = ${PROJECT_ROOT}/jni/chicken/host/${PACKAGE_NAME}/bin/
CHICKEN_INSTALL = ${CHICKEN_BIN}/android-chicken-install

main: ${CHICKEN_BIN}/android-csc
	${CHICKEN_BIN}/android-csc -t jni/entry/entry.scm
	ndk-build
	make -C jni/chicken libs # copies eggs/units with lib prefix (sigh ...)
	ant clean debug
	adb install -r bin/SDLActivity-debug.apk

${CHICKEN_BIN}/android-csc:
	ndk-build # <-- this should trigger building chicken-core

# ==================== useful eggs ====================

# Here's how you can explicitly install an egg. It should all end up
# under both jni/chicken/target and /jni/chicken/host. Note that `make
# jni/chicken libs` above copies these into ./libs/${TARGET} with a
# touch of magic (to get the Android build.xml to pick them up).

# you should be able to do `make sdl2` from the project root. however,
# `-keep-installed` is very very tricky because:
# - it installs for host, then target
# - `-keep-installed` only checks if egg already exists for host
# - thus, if target installation fails, it won't retry
sdl2:
	SDL2_FLAGS="\
		-I${PROJECT_ROOT}/jni/SDL \
		-I${PROJECT_ROOT}/jni/SDL/include \
		-L${PROJECT_ROOT}/libs/armeabi/ \
		-lSDL2" \
	${CHICKEN_INSTALL} -keep-installed sdl2

nrepl:
	${CHICKEN_INSTALL} -keep-installed nrepl
