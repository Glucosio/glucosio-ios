#import "GLUCAboutViewController.h"

@implementation GLUCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = GLUCLoc(@"Version 0.0.0");
}

- (NSURL *)url {
    return [NSURL URLWithString:kGLUCDefaultHomePageURLString];
}

@end
