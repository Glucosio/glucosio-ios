#import "GLUCWebViewController.h"
#import "SVProgressHUD.h"

@interface GLUCWebViewController ()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

@implementation GLUCWebViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allowLinks = YES;
    self.webView = self.webViewWrappper.webView;
    self.webView.navigationDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [SVProgressHUD dismiss];
}

- (NSURL *)url {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ method in GLUCWebViewController's subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.loading = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.loading = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.loading = NO;
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

// Prevent navigation away from the first page specified.
// URL's must match request to prevent navigation - check trailing '/'
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (self.allowLinks) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        BOOL sameURL = [navigationAction.request.URL.absoluteString isEqualToString:self.url.absoluteString];
        WKNavigationActionPolicy decision = (sameURL) ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel;
        decisionHandler(decision);
    }
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
