#import <UIKit/UIKit.h>
#import "GLUCWebViewController.h"

static NSString *const kGLUCTOSUrlString = @"http://www.glucosio.org/terms/";

@interface GLUCEULAViewController : GLUCWebViewController

@property (nonatomic, assign) BOOL requireConfirmation;

- (IBAction)save:(UIButton *)sender;

@end
