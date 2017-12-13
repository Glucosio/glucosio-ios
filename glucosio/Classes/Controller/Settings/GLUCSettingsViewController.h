#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GLUCViewController.h"

@class GLUCUser;


static NSString *const kGLUCAppNameKey = @"app_name";

static NSString *const kGLUCSettingsCellIdentifier = @"SettingsCell";

@interface GLUCSettingsViewController : GLUCViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

// Set this to use the view controller as the initial welcome view
@property (nonatomic, readwrite, assign) BOOL welcomeMode;
//@property (nonatomic, readwrite, strong) GLUCUser *user;

@end
