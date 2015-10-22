#import <Foundation/Foundation.h>
#import "GLUCEditorViewController.h"

@interface GLUCDateTimeEditorViewController : GLUCEditorViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (strong, nonatomic) NSDate *editedDate;

@end