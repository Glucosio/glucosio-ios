#import <Foundation/Foundation.h>
#import "GLUCEditorViewController.h"
#import "GLUCBloodGlucoseReading.h"

static NSString *const kGLUCReadingEditorTableViewCellIdentifier = @"ReadingEditorTableViewCell";

@interface GLUCReadingEditorViewController : GLUCEditorViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, strong) IBOutlet UITableView *editorTableView;
@property (nonatomic, readwrite, strong) IBOutlet UITextField *valueField;
@property (nonatomic, readwrite, strong) IBOutlet UILabel *unitsLabel;

@end