#import <UIKit/UIKit.h>
#import "GLUCViewController.h"

@interface GLUCEventDateTimeEditorViewController : GLUCViewController 

@property (strong, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *repeatIntervalControl;
@property (strong, nonatomic) UILocalNotification *editedEvent;
@property (strong, nonatomic) IBOutlet UILabel *repeatLabel;


@end
