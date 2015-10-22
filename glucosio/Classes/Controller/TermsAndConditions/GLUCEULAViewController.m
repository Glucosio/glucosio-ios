#import "GLUCEULAViewController.h"
#import "GLUCLoc.h"
#import "GLUCAppDelegate.h"
#import "GLUCAppearanceController.h"

@implementation GLUCEULAViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.eulaView.text = GLUCLoc(@"Terms Full");
    self.eulaView.editable = NO;
    self.eulaView.font = [GLUCAppearanceController defaultFont];
    [self.saveButton setTitle:GLUCLoc(@"Accept") forState:UIControlStateNormal];
    
}

- (void) viewWillAppear:(BOOL)animated {
    if (!self.requireConfirmation) {
        self.saveButton.hidden = YES;
    }
    [super viewWillAppear:animated];
}

- (IBAction)save:(UIButton *)sender {
    [(GLUCAppDelegate *)[[UIApplication sharedApplication] delegate] showOverview];
}

@end
