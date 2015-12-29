LOCAL_PATH := $(call my-dir)

# try to autodetect package name
PACKAGE_NAME       := $(shell csi -s $(LOCAL_PATH)/find-package.scm AndroidManifest.xml)
CHICKEN_TARGET_OUT := $(shell pwd)/$(LOCAL_PATH)/target/
SYS_PREFIX         := /data/data/$(PACKAGE_NAME)

# target chicken dir, containing ./lib and ./include
CHICKEN_PATH := $(CHICKEN_TARGET_OUT)$(SYS_PREFIX)/

include $(CLEAR_VARS)
LOCAL_PATH              := $(CHICKEN_PATH)
LOCAL_MODULE            := chicken
LOCAL_SRC_FILES         := lib/libchicken.so
LOCAL_EXPORT_C_INCLUDES := $(CHICKEN_PATH)/include/chicken/
include $(PREBUILT_SHARED_LIBRARY)

