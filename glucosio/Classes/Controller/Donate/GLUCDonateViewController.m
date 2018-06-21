#import "GLUCDonateViewController.h"

@implementation GLUCDonateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allowLinks = YES;
    
    self.title = GLUCLoc(@"donate_action_title");
}

- (NSURL *)url {
    return [NSURL URLWithString:GLUCLoc(kGLUCDefaultDonatePageURLStringKey)];
}

@end
