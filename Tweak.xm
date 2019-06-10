@interface SBDashBoardStatusTextViewController
- (NSString *)_legalString;
@end

NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.artikus.externalizerprefs.plist"];
NSString *stolenInternalLegalText;

%hook SBDashBoardStatusTextViewController

- (void)setPresentationType:(int)style { %orig(1); }
- (void)setPresentationPriority:(int)priority { %orig(4); }
- (void)setPresentationTransition:(int)transition { %orig(1); }

- (instancetype)init {
  self = %orig;
  stolenInternalLegalText = [self _legalString];
  return self;
}

%end

%hook SBDashBoardStatusTextView

- (void)setInternalLegalText:(NSString *)internalLegalText {
  if([[prefs objectForKey:@"kInternalLegalEnabledCustom"] boolValue]) {
    NSString *customText = [prefs objectForKey:@"kInternalLegalText"];
    if(customText && customText.length > 0) %orig(customText);
  } else if([[prefs objectForKey:@"kInternalLegalEnabledApple"] boolValue]) %orig(stolenInternalLegalText);
}

%end

%hook SBDashBoardStatusTextView

- (void)setProvisionalEnrollmentText:(NSString *)provisionalEnrollmentText {
  NSString *customText = [prefs objectForKey:@"kProvisionalEnrollmentText"];
  if(customText && customText.length != 0) %orig(customText);
  else %orig;
}

%end

%hook SBDashBoardStatusTextView

- (void)setSupervisionText:(NSString *)text {
  NSString *customText = [prefs objectForKey:@"kSupervisionText"];
  if(customText && customText.length != 0) %orig(customText);
  else %orig;
}

%end

%hook SBDashBoardStatusTextView

- (void)setDeviceInformationText:(NSArray *)deviceInformationText {
  NSString *customText = [prefs objectForKey:@"kDeviceInfoText"];
  if(customText && customText.length != 0) %orig(@[customText]);
  else %orig;
}

%end
