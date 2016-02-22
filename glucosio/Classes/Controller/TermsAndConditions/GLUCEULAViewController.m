#import "GLUCEULAViewController.h"
#import "GLUCLoc.h"
#import "GLUCAppDelegate.h"
#import "GLUCAppearanceController.h"

@implementation GLUCEULAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.saveButton setTitle:GLUCLoc(@"helloactivity_button_next") forState:UIControlStateNormal];
}

- (NSURL *)url {
    return [NSURL URLWithString:kGLUCTOSUrlString];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupUI];
}

- (void)setupUI {
    if (!self.requireConfirmation) {
        [self.saveButton removeFromSuperview];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.view addConstraint:bottom];
    }
}

- (IBAction)save:(UIButton *)sender {
    [(GLUCAppDelegate *)[[UIApplication sharedApplication] delegate] showOverview];
}

@end

