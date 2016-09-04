#import <UIKit/UIKit.h>
#import "GLUCPersistenceController.h"

static NSString *const kGLUCScheduleNotificationReadingTypeKey = @"ScheduleNotificationReadingTypeKey";

@interface GLUCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (GLUCPersistenceController *) appModel;
- (void) showOverview;

@end
