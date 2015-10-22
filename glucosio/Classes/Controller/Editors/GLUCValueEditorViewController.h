#import <Foundation/Foundation.h>
#import "GLUCEditorViewController.h"

@interface GLUCValueEditorViewController : GLUCEditorViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;

@end