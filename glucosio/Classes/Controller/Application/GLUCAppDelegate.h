#import <UIKit/UIKit.h>
#import "GLUCPersistenceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

static NSString *const kGLUCScheduleNotificationReadingTypeKey = @"ScheduleNotificationReadingTypeKey";

@interface GLUCAppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

- (GLUCPersistenceController *) appModel;
- (void) showOverview;

@end
