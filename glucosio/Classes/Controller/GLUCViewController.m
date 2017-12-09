#import "GLUCViewController.h"
#import "GLUCAppDelegate.h"



@implementation GLUCViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.positiveFormat = @"0.00";
    
    if (!self.model) {
        self.model = [(GLUCAppDelegate *) [[UIApplication sharedApplication] delegate] appModel];
    }    

    self.model.currentUser.numberFormatter = self.numberFormatter;
}


- (UIBarButtonItem *) cancelButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:GLUCLoc(@"dialog_add_cancel") style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
