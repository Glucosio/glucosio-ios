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

/**
 * Allow user to navigate away from initial page or not
 */

@property (nonatomic, assign) BOOL allowLinks;

@end