#import "GLUCAboutViewController.h"

@implementation GLUCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kGLUCDefaultHomePageURLString]]];
    self.title = GLUCLoc(@"Version 0.0.0");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {

}

@end
