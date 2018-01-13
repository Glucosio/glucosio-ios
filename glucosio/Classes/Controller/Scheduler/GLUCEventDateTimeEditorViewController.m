#import <Realm/RLMArray.h>
#import "GLUCEventDateTimeEditorViewController.h"
#import "GLUCAppDelegate.h"
#import "GLUCAppearanceController.h"
#import "NSCalendar+GLUCAdditions.h"

@interface GLUCEventDateTimeEditorViewController ()
@property (strong, nonatomic) UITableViewRowAction *deleteAction;
@property (strong, nonatomic) UITableViewRowAction *editAction;
@property (strong, nonatomic) NSArray *notificationTypes;
@property (strong, nonatomic) UIApplication *notificationModel;
@property (strong, nonatomic) GLUCAppDelegate *appDelegate;
@end

@implementation GLUCEventDateTimeEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pickerView.calendar = [NSCalendar currentCalendar];
    self.editedEvent = nil;
    [self.pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    NSArray *segmentTitles = @[
                               GLUCLoc(@"None"),
                               GLUCLoc(@"Daily"),
                               GLUCLoc(@"Weekly"),
                               GLUCLoc(@"Monthly")
                               ];
    
    [self.repeatIntervalControl removeAllSegments];
    
    NSUInteger segmentIndex = 0;
    for (NSString *segmentTitle in segmentTitles) {
        [self.repeatIntervalControl insertSegmentWithTitle:segmentTitle atIndex:segmentIndex++ animated:NO];
    }
    
    self.repeatLabel.text = GLUCLoc(@"Repeats?");

    self.navigationItem.leftBarButtonItem = [self cancelButtonItem];

}

- (NSCalendarUnit) calendarIntervalForSegmentIndex:(NSInteger)index {
    NSCalendarUnit retVal = NSCalendarUnitNanosecond;
    
    switch (index) {
        case 0:
        default:
            break;
        case 1:
            retVal = NSCalendarUnitDay;
            break;
        case 2:
            retVal = NSCalendarUnitWeekOfMonth;
            break;
        case 3:
            retVal = NSCalendarUnitMonth;
            break;
    }
    return retVal;
}

- (NSInteger) segmentIndexForRepeatInterval {
    NSInteger retVal = 0;
    
    // ACF removed the 0 case which wasnt a valid enum value
    switch (self.editedEvent.repeatInterval) {
        default:
            break;
        case NSCalendarUnitDay:
            retVal = 1;
            break;
        case NSCalendarUnitWeekOfMonth:
            retVal = 2;
            break;
        case NSCalendarUnitMonth:
            retVal = 3;
            break;
    }
    
    return retVal;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pickerView.date = self.editedEvent.fireDate;
    
    self.repeatIntervalControl.selectedSegmentIndex = [self segmentIndexForRepeatInterval];
    
}

- (void) dateChanged:(id) sender {
    self.editedEvent.fireDate = [self.pickerView date];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    if (self.editedEvent) {
        NSCalendarUnit specifiedInterval = [self calendarIntervalForSegmentIndex:self.repeatIntervalControl.selectedSegmentIndex];
        if (specifiedInterval == NSCalendarUnitNanosecond) {
            // none
            self.editedEvent.repeatInterval = 0;
        } else {
            self.editedEvent.repeatInterval = specifiedInterval;
        }
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:self.editedEvent];
    }    
    
}

@end
