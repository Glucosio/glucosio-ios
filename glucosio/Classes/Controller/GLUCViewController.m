#import "GLUCViewController.h"
#import "GLUCAppDelegate.h"



@implementation GLUCViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.model) {
        self.model = [(GLUCAppDelegate *) [[UIApplication sharedApplication] delegate] appModel];
    }    

    self.numberFormatter = self.model.currentUser.numberFormatter;
}

- (IBAction) cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *) cancelButtonItem {
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    
    [cancelButton setTitle:GLUCLoc(@"Cancel") forState:UIControlStateNormal];
    [cancelButton.widthAnchor constraintEqualToConstant:80].active = YES;
    [cancelButton.heightAnchor constraintEqualToConstant:35].active = YES;
    
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

@end
