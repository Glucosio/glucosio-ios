#import "GLUCTabBarController.h"
#import "GLUCLoc.h"
#import "GLUCReadingEditorViewController.h"
#import "GLUCHistoryViewController.h"
#import "NSCalendar+GLUCAdditions.h"
#import "GLUCBloodGlucoseReading.h"
#import "GLUCHB1ACReading.h"
#import "GLUCCholesterolReading.h"
#import "GLUCBloodPressureReading.h"
#import "GLUCKetonesReading.h"
#import "GLUCBodyWeightReading.h"
#import "GLUCInsulinIntakeReading.h"


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

- (void) addReadingOfSelectedType:(Class)readingType {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:kGLUCMainStoryboardIdentifier bundle:nil];
    if (mainStoryboard) {
        GLUCReadingEditorViewController *editorVC = (GLUCReadingEditorViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:kGLUCReadingEditorViewControllerIdentifier];
        if (editorVC) {
            if ([readingType isSubclassOfClass:[GLUCReading class]]) {
                id newReading = [[readingType alloc] init];
                editorVC.title = [NSString stringWithFormat:@"%@ %@", GLUCLoc(@"Add"), GLUCLoc([readingType title])];
                editorVC.editedObject = newReading;
                
                UINavigationController *editorNavCtrl = [[UINavigationController alloc] initWithRootViewController:editorVC];
                [self presentViewController:editorNavCtrl animated:YES completion:^{}];
            }
        }
    }
    
}
- (void) addReading:(id)sender {
    NSArray *readingTypes = [self.model.currentUser readingTypes];
    
    UIAlertController *readingTypeSelector = [UIAlertController alertControllerWithTitle:GLUCLoc(@"Choose Measurement")
                                                                                 message:GLUCLoc(@"Select a reading type")
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (Class readingType in readingTypes) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:[readingType title] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self addReadingOfSelectedType:readingType];
        }];
        [readingTypeSelector addAction:action];
    }
    [self presentViewController:readingTypeSelector animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
