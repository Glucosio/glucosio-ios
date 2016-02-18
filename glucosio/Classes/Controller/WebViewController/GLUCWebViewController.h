#import <UIKit/UIKit.h>
#import "GLUCEditorViewController.h"

@interface GLUCWebViewController : GLUCEditorViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;


/**
 *  Return the url that webView have to load. You MUST implement this method in your subclass.
 *
 *  @return The NSURL to load
 */
- (NSURL *)url;

@end