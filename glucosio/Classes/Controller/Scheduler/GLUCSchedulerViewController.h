#import <UIKit/UIKit.h>
#import "GLUCViewController.h"

static NSString *const kGLUCSchedulerCellIdentifier = @"SchedulerCell";

@interface GLUCSchedulerViewController : GLUCViewController <UITableViewDataSource, UITableViewDelegate,  GLUCViewControllerRecordCreation>

@property (strong, nonatomic, readwrite) IBOutlet UITableView *notificationTableView;
@property (strong, nonatomic) NSArray <UILocalNotification *> *notifications;

- (IBAction)add:(id)sender; // Add a new scheduled notification

@end
