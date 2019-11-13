target+= iphone:12.1.2:10.0

ARCHS = arm64

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
