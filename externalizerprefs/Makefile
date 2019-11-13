ARCHS = arm64

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = externalizerprefs
externalizerprefs_FILES = EXPRootListController.m
externalizerprefs_INSTALL_PATH = /Library/PreferenceBundles
externalizerprefs_FRAMEWORKS = UIKit
externalizerprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/externalizerprefs.plist$(ECHO_END)
