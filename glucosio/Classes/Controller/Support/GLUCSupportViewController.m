#import "GLUCSupportViewController.h"

@implementation GLUCSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allowLinks = YES;
    
    self.title = GLUCLoc(@"support_action_title");
}

- (NSURL *)url {
    return [NSURL URLWithString:GLUCLoc(kGLUCDefaultSupportPageURLStringKey)];
}

@end
