#import <UIKit/UIKit.h>
#import "GLUCEditorViewController.h"

@interface GLUCEULAViewController : GLUCEditorViewController

@property (nonatomic, strong) IBOutlet UITextView *eulaView;

@property (nonatomic, assign) BOOL requireConfirmation;

- (IBAction)save:(UIButton *)sender;

@end
