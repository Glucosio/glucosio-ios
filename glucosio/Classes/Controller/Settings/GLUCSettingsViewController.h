#import <UIKit/UIKit.h>
#import "GLUCViewController.h"

@class GLUCUser;


static NSString *const kGLUCAppNameKey = @"app_name";

static NSString *const kGLUCSettingsCellIdentifier = @"SettingsCell";

@interface GLUCSettingsViewController : GLUCViewController <UITableViewDataSource, UITableViewDelegate>

// Set this to use the view controller as the initial welcome view
@property (nonatomic, readwrite, assign) BOOL welcomeMode;
//@property (nonatomic, readwrite, strong) GLUCUser *user;

@end
