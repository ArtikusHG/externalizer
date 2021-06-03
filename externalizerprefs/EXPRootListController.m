#include "EXPRootListController.h"
#include <Preferences/PSSpecifier.h>
#include "../include.h"

NSDictionary *prefsDict() {
  if (@available(iOS 11, *)) return [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:@settingsPlist] error:nil] ? : [NSDictionary dictionary];
  return [NSDictionary dictionaryWithContentsOfFile:@settingsPlist] ? : [NSDictionary dictionary];
}
void writePrefsDict(NSDictionary *dict) {
  if (@available(iOS 11, *)) [dict writeToURL:[NSURL fileURLWithPath:@settingsPlist] error:nil];
  else [dict writeToFile:@settingsPlist atomically:YES];
}

@implementation EXPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  NSMutableDictionary *prefs = [prefsDict() mutableCopy];
  [prefs setObject:value forKey:[specifier propertyForKey:@"key"]];
  writePrefsDict(prefs);
  [[CPDistributedMessagingCenter centerNamed:@"com.artikus.externalizerprefs"] sendMessageAndReceiveReplyName:@"updatePrefs" userInfo:prefs error:nil];
}

- (id)readPreferenceValue:(PSSpecifier *)specifier { return prefsDict()[[specifier propertyForKey:@"key"]]; }

@end
