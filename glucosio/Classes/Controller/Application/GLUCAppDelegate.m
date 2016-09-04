#import "GLUCAppDelegate.h"
#import "GLUCSettingsViewController.h"
#import "GLUCAppearanceController.h"
#import "GLUCOverviewViewController.h"
#import "GLUCHistoryViewController.h"

@interface GLUCAppDelegate ()
@property (strong, nonatomic) GLUCPersistenceController *model;
@end

@implementation GLUCAppDelegate

- (GLUCPersistenceController *) appModel {
    if (!self.model) {
        self.model = [[GLUCPersistenceController alloc] init];
        [self.model configureModel];
    }
    return self.model;
}

- (void) showOverview {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:kGLUCMainStoryboardIdentifier bundle:nil];
    
    if (mainStoryboard) {
        GLUCOverviewViewController *overviewVC = (GLUCOverviewViewController *)[mainStoryboard instantiateInitialViewController];
        if (overviewVC) {
            overviewVC.title = GLUCLoc(kGLUCAppNameKey);
            overviewVC.model = [self appModel];
            
            UINavigationController *mainNavCtrl = [[UINavigationController alloc] initWithRootViewController:overviewVC];
            self.window.rootViewController = mainNavCtrl;            
        }
    }
}

- (void) registerAppForNotifications:(UIApplication *)app {
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                             UIUserNotificationTypeSound |
                                                             UIUserNotificationTypeAlert);
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [app registerUserNotificationSettings:mySettings];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL showSettingsViewController = ![[NSUserDefaults standardUserDefaults] boolForKey:kGLUCModelInitialSettingsCompletedKey];

    [GLUCAppearanceController setAppearanceDefaults];

    [self registerAppForNotifications:application];
    
    if (showSettingsViewController) {
        UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:kGLUCSettingsStoryboardIdentifier bundle:nil];
        if (settingsStoryboard) {
            GLUCSettingsViewController *settingsVC = (GLUCSettingsViewController *)[settingsStoryboard instantiateInitialViewController];
            if (settingsVC) {
                settingsVC.welcomeMode = YES;
                settingsVC.model = [self appModel];

                UINavigationController *setupNavCtrl = [[UINavigationController alloc] initWithRootViewController:settingsVC];
                self.window.rootViewController = setupNavCtrl;
            }
        }
    } else {
        [self showOverview];
    }
    
    [self.window makeKeyAndVisible];

    return YES;
}

-(void)showSimpleAlertMessage:(NSString*)message withTitle:(NSString *)title
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:GLUCLoc(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    
    [alert addAction:okAction];
    UIViewController *vc = [self.window rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
    
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if (application.applicationState == UIApplicationStateActive) {
        [self showSimpleAlertMessage:notification.alertBody withTitle:notification.alertTitle];
    } else {
        // TODO: go ahead and navigate to the add reading view controller for the
        // type of reading specified in the user dict.
    }
}

@end
