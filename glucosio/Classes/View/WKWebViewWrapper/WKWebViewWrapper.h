
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

/**
 *  This class is only a WKWebView wrapper to make it easy to use in InterfaceBuilder with autolayout
 */
IB_DESIGNABLE
@interface WKWebViewWrapper : UIView

/**
 * This is the WKWebView contained inside the wrapper.
 * IMPORTANT: if you want to change its bounds or frame property, change the bounds frame property of the wrapper
 */
@property (strong, nonatomic, readonly) WKWebView *webView;

@end
