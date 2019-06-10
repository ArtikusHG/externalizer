target += iphone:12.1.4:10.0
FINALPACKAGE = 1
DEBUG = 0

ARCHS = armv7s arm64 arm64e

THEOS_DEVICE_IP = 192.168.0.87

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Externalizer
Externalizer_FILES = Tweak.xm
Externalizer_CFLAGS = -objc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += externalizerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
