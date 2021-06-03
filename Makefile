INSTALL_TARGET_PROCESSES = SpringBoard

export DEBUG = 0
export FINALPACKAGE = 1
export TARGET = iphone:clang:14.4:10.0

export ARCHS = armv7s arm64 arm64e
#export ARCHS = arm64

#THEOS_DEVICE_IP = 192.168.1.159
THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Externalizer
Externalizer_FILES = Tweak.xm
Externalizer_PRIVATE_FRAMEWORKS = AppSupport
Externalizer_CFLAGS = -fobjc-arc -Wall

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += externalizerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
