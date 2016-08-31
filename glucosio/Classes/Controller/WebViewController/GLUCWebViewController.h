#import <UIKit/UIKit.h>
#import "WKWebViewWrapper.h"
#import "GLUCEditorViewController.h"

@interface GLUCWebViewController : GLUCEditorViewController

@property (strong, nonatomic) IBOutlet WKWebViewWrapper *webViewWrappper;

/**
 *  Return the url that webView have to load. You MUST implement this method in your subclass.
 *
 *  @return The NSURL to load
 */
- (NSURL *)url;

/**
 * Allow user to navigate away from initial page or not
 */

@property (nonatomic, assign) BOOL allowLinks;

@end