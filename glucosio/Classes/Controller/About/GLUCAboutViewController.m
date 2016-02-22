#import "GLUCAboutViewController.h"

@implementation GLUCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = GLUCLoc(@"version");
}

- (NSURL *)url {
    return [NSURL URLWithString:kGLUCDefaultHomePageURLString];
}

@end
