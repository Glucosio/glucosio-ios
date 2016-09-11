#import "GLUCAboutViewController.h"

@implementation GLUCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allowLinks = NO;
    
    NSString *bundleShortVersionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *bundleVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
    self.title = [NSString stringWithFormat:@"%@ %@ (%@)", GLUCLoc(@"version_label"),
                  bundleShortVersionString, bundleVersion];
}

- (NSURL *)url {
    return [NSURL URLWithString:kGLUCDefaultHomePageURLString];
}

@end
