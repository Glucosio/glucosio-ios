#import <UIKit/UIKit.h>
#import "GLUCPersistenceController.h"

@interface GLUCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (GLUCPersistenceController *) appModel;
- (void) showOverview;

@end
