#import "GLUCWebViewController.h"
#import "SVProgressHUD.h"

@interface GLUCWebViewController ()

@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

@implementation GLUCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (NSURL *)url {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ method in GLUCWebViewController's subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - UIWebViewDelegate

// Prevent navigation away from the first page specified.
// URL's must match request to prevent navigation - check trailing '/'

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return self.allowLinks ? YES : ([request.URL.absoluteString isEqualToString:self.url.absoluteString]);
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loading = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loading = NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    self.loading = NO;
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

#pragma mark - Accessors

- (void)setLoading:(BOOL)loading
{
    if (loading == YES) {
        [SVProgressHUD showWithStatus:GLUCLoc(@"Loading")];
    } else {
        [SVProgressHUD dismiss];
    }
}

@end
