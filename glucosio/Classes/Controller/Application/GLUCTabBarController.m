#import "GLUCTabBarController.h"
#import "GLUCLoc.h"
#import "GLUCReadingEditorViewController.h"
#import "GLUCHistoryViewController.h"

@interface GLUCTabBarController ()

@end

@implementation GLUCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addReading:)];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *tabItemTitlesLoc = @[GLUCLoc(@"tab_overview"), GLUCLoc(@"tab_history"), GLUCLoc(@"action_settings")];
    int tabItemIndex = 0;
    for (UITabBarItem *tabItem in self.tabBar.items) {
        tabItem.image = [tabItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabItem.title = tabItemTitlesLoc[tabItemIndex++];
    }
    
}

- (void) addReading:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:kGLUCMainStoryboardIdentifier bundle:nil];
    if (mainStoryboard) {
        GLUCReadingEditorViewController *editorVC = (GLUCReadingEditorViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:kGLUCReadingEditorViewControllerIdentifier];
        if (editorVC) {
            editorVC.title = GLUCLoc(@"assistant_action_reading");
            editorVC.editedObject = [[GLUCBloodGlucoseReading alloc] init];
            UINavigationController *editorNavCtrl = [[UINavigationController alloc] initWithRootViewController:editorVC];
            [self presentViewController:editorNavCtrl animated:YES completion:^{
            }];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
