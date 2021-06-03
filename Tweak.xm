#include "include.h"

@interface CSStatusTextView
@property (nonatomic, copy) NSString *internalLegalText;
@property (nonatomic, copy) NSString *supervisionText;
@property (nonatomic, copy) NSString *provisionalEnrollmentText;
@property (nonatomic, copy) NSArray *deviceInformationText;
@end

@interface CSStatusTextViewController
- (NSString *)_legalString;
@end

NSDictionary *prefs;

void loadPrefs() {
  if (@available(iOS 11, *)) prefs = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:@settingsPlist] error:nil] ? : [NSDictionary dictionary];
  else prefs = [NSDictionary dictionaryWithContentsOfFile:@settingsPlist] ? : [NSDictionary dictionary];
}

%hook CSStatusTextViewController

- (void)viewWillAppear:(BOOL)willAppear {
  %orig;
  CSStatusTextView *view = MSHookIvar<CSStatusTextView *>(self, "_view");
  if ([[prefs objectForKey:@"kInternalLegalEnabledApple"] boolValue]) view.internalLegalText = [self _legalString];
  else if (NSString *internalLegalText = prefs[@"kInternalLegalText"]) view.internalLegalText = internalLegalText;
  if (NSString *supervisionText = prefs[@"kSupervisionText"]) view.supervisionText = supervisionText;
  if (kCFCoreFoundationVersionNumber >= 1443.00) if (NSString *provisionalEnrollmentText = prefs[@"kProvisionalEnrollmentText"]) view.provisionalEnrollmentText = provisionalEnrollmentText;
  if (NSString *deviceInfoText = prefs[@"kDeviceInfoText"]) view.deviceInformationText = @[deviceInfoText];
}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
  %orig;
  CPDistributedMessagingCenter *center = [CPDistributedMessagingCenter centerNamed:@"com.artikus.externalizerprefs"];
  [center runServerOnCurrentThread];
  [center registerForMessageName:@"updatePrefs" target:self selector:@selector(updatePrefs:message:)];
}

%new
- (NSDictionary *)updatePrefs:(NSString *)name message:(NSDictionary *)dict {
  prefs = dict;
  return nil;
}

%end

%ctor {
  loadPrefs();
  Class hookClass = (kCFCoreFoundationVersionNumber >= 1665.15) ? NSClassFromString(@"CSStatusTextViewController") : NSClassFromString(@"SBDashBoardStatusTextViewController");
  %init(CSStatusTextViewController = hookClass);
}
