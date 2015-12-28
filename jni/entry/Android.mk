LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := main

SDL_PATH := ../SDL

LOCAL_C_INCLUDES := $(LOCAL_PATH)/$(SDL_PATH)/include

LOCAL_SRC_FILES := $(SDL_PATH)/src/main/android/SDL_android_main.c entry.c
LOCAL_CFLAGS := -D GLES
LOCAL_SHARED_LIBRARIES := SDL2 chicken

LOCAL_LDLIBS := -lGLESv3 -llog

include $(BUILD_SHARED_LIBRARY)
