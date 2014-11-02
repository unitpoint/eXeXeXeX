LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := main

#SDK_ROOT points to folder with SDL and oxygine-framework
LOCAL_SRC_FILES := ../../../../../SDL/src/main/android/SDL_android_main.c

LOCAL_SRC_FILES += ../../../../../objectscript/src/objectscript.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/os-heap.cpp

LOCAL_SRC_FILES += ../../../../../objectscript/src/ext-datetime/os-datetime.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/ext-json/os-json.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/ext-url/os-url.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/ext-base64/os-base64.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/ext-base64/cencode.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/ext-base64/cdecode.cpp

LOCAL_SRC_FILES += \
				$(subst $(LOCAL_PATH)/,, \
				$(wildcard $(LOCAL_PATH)/../../../../../objectscript/src/ext-hashlib/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../objectscript/src/ext-hashlib/des/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../objectscript/src/ext-hashlib/md5/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../objectscript/src/ext-hashlib/sha/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../objectscript/src/ext-hashlib/crc32/*.c) \
				)

LOCAL_SRC_FILES += ../../../../../objectscript/src/ext-zlib/os-zlib.cpp
LOCAL_SRC_FILES += \
				$(subst $(LOCAL_PATH)/,, \
				$(wildcard $(LOCAL_PATH)/../../../../../objectscript/src/ext-zlib/zlib/*.c) \
				)
				
LOCAL_SRC_FILES += ../../../../../objectscript/src/EaseFunction.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/ox-binder.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/ox-sound-binder.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/ox-physics.cpp
LOCAL_SRC_FILES += ../../../../../objectscript/src/MathLib.cpp

LOCAL_SRC_FILES += ../../../src/example.cpp ../../../src/entry_point.cpp 
LOCAL_SRC_FILES += ../../../src/RandomValue.cpp
LOCAL_SRC_FILES += ../../../src/BaseGame4X.cpp
LOCAL_SRC_FILES += ../../../src/Box2DDebugDraw.cpp

LOCAL_SRC_FILES += \
				$(subst $(LOCAL_PATH)/,, \
				$(wildcard $(LOCAL_PATH)/../../../../../Box2D/Box2D/Collision/Shapes/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../Box2D/Box2D/Collision/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../Box2D/Box2D/Common/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../Box2D/Box2D/Dynamics/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../Box2D/Box2D/Dynamics/Contacts/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../Box2D/Box2D/Dynamics/Joints/*.cpp) \
				$(wildcard $(LOCAL_PATH)/../../../../../Box2D/Box2D/Rope/*.cpp) \
				)
				
LOCAL_STATIC_LIBRARIES := oxygine-framework_static oxygine-sound_static
LOCAL_SHARED_LIBRARIES := SDL2

LOCAL_CFLAGS += -DOX_WITH_OBJECTSCRIPT
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../objectscript/src
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../Box2D

LOCAL_EXPORT_C_INCLUDES += $(LOCAL_C_INCLUDES)
LOCAL_EXPORT_CFLAGS += $(LOCAL_CFLAGS)

include $(BUILD_SHARED_LIBRARY)

#import from NDK_MODULE_PATH defined in build.cmd
$(call import-module, oxygine-framework)
$(call import-module, oxygine-sound)
