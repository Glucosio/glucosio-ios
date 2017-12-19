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


- (UIBarButtonItem *) cancelButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:GLUCLoc(@"dialog_add_cancel") style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
