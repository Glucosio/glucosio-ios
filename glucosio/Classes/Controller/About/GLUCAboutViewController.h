#import <UIKit/UIKit.h>
#import "GLUCViewController.h"

static NSString *const kGLUCDefaultHomePageURLString = @"https://www.glucosio.org";

@interface GLUCAboutViewController : GLUCViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
