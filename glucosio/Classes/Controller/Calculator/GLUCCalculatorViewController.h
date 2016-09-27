#import <UIKit/UIKit.h>
#import "GLUCViewController.h"

@class GLUCUser;


static NSString *const kGLUCCalculatorCellIdentifier = @"CalculatorCell";

@interface GLUCCalculatorViewController : GLUCViewController <UITextFieldDelegate, GLUCViewControllerRecordCreation>

- (IBAction)add:(id)sender; // Add a new scheduled notification

@end
