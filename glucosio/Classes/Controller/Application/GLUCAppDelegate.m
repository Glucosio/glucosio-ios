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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL showSettingsViewController = ![[NSUserDefaults standardUserDefaults] boolForKey:kGLUCModelInitialSettingsCompletedKey];

    [GLUCAppearanceController setAppearanceDefaults];

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


@end
