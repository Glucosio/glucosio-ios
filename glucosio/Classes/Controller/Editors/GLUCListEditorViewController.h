#import <Foundation/Foundation.h>
#import "GLUCEditorViewController.h"

@interface GLUCListEditorViewController : GLUCEditorViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic, readwrite) NSArray *items;
@property (assign, nonatomic) NSUInteger selectedItemIndex;

@end