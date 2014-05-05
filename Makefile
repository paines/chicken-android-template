
PROJECT_ROOT=${PWD}

main:
	csc -t jni/src/YourSourceHere.scm # generates YourSourceHere.c as requested by ndk-build
	ndk-build
	make -C jni/chicken libs # copies eggs/units with lib prefix (sigh ...)
	ant clean debug
	adb install -r bin/SDLActivity-debug.apk 

sdl2-egg:
	cd ../../chicken-sdl2 ; \
	 CSC_OPTIONS="-I${PROJECT_ROOT}/jni/SDL/include/ -lSDL2 -L${PROJECT_ROOT}/obj/local/armeabi/" \
	 ${PROJECT_ROOT}/jni/chicken/host/org.libsdl.app/bin/android-chicken-install 
