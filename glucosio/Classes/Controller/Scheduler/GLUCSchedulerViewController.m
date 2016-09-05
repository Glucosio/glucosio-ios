#import <Realm/RLMArray.h>
#import "GLUCSchedulerViewController.h"
#import "GLUCEventDateTimeEditorViewController.h"
#import "GLUCAppDelegate.h"
#import "GLUCAppearanceController.h"
#import "NSCalendar+GLUCAdditions.h"

@interface GLUCSchedulerViewController ()
@property (strong, nonatomic) UITableViewRowAction *deleteAction;
@property (strong, nonatomic) UITableViewRowAction *editAction;
@property (strong, nonatomic) NSArray *notificationTypes;
@property (strong, nonatomic) UIApplication *notificationModel;
@property (strong, nonatomic) GLUCAppDelegate *appDelegate;
@end

@implementation GLUCSchedulerViewController

- (UILocalNotification *) eventAtIndexPath:(NSIndexPath *)indexPath {
    UILocalNotification *retVal = nil;
    
    if (indexPath && indexPath.row < self.notifications.count) {
        retVal = self.notifications[(NSUInteger)indexPath.row];
    }
    return retVal;
}

- (void) editEvent:(UILocalNotification *)event {
    GLUCEventDateTimeEditorViewController *editor = (GLUCEventDateTimeEditorViewController *)[[UIStoryboard storyboardWithName:kGLUCSettingsStoryboardIdentifier bundle:nil] instantiateViewControllerWithIdentifier:@"EventDateTimeEditor"];
    UIView *v = [editor view]; // force load from xib
    if (v) {
        editor.editedEvent = [event copy];
        
        [[UIApplication sharedApplication] cancelLocalNotification:event];
        
        editor.title = @"Reminder Date/Time";
        editor.model = self.model;
        editor.pickerView.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    self.navigationItem.backBarButtonItem = [self cancelButtonItem];
    [self.navigationController pushViewController:editor animated:YES];
    
}

- (void) viewDidLoad {
    [super viewDidLoad];


    if (!self.model) {
        self.notificationModel = [UIApplication sharedApplication];
        self.appDelegate = (GLUCAppDelegate *)[self.notificationModel delegate];
        self.model = [self.appDelegate appModel];
    }
    
    self.notificationTypes = [self.model.currentUser readingTypes];

    self.deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                           title:GLUCLoc(@"dialog_delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        UILocalNotification *targetNotification = [self eventAtIndexPath:indexPath];
        if (targetNotification) {
            [self.notificationModel cancelLocalNotification:targetNotification];
            self.notifications = self.notificationModel.scheduledLocalNotifications;
            self.notificationTableView.editing = NO;
            [self.notificationTableView reloadData];
        }
    }];
    
    self.editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                         title:GLUCLoc(@"Edit") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        self.notificationTableView.editing = NO;
        UILocalNotification *targetNotification = [self eventAtIndexPath:indexPath];
        if (targetNotification) {
            [self editEvent:targetNotification];            
        }
    }];
    
    self.title = GLUCLoc(@"tab_scheduler");

}

- (void) viewWillAppear:(BOOL)animated {
    self.notifications =  self.notificationModel.scheduledLocalNotifications;
    
    [self.notificationTableView reloadData];
    [super viewWillAppear:animated];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifications.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    UILocalNotification *targetNotification = [self eventAtIndexPath:indexPath];
    if (targetNotification) {
        [self editEvent:targetNotification];
    }

}

- (NSArray *) tableView:tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return @[self.deleteAction,self.editAction];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kGLUCSchedulerCellIdentifier];
    
    UILocalNotification *notification = nil;
    
    if (indexPath.row >= 0 && indexPath.row < self.notifications.count) {
        notification = self.notifications[(NSUInteger) indexPath.row];
    }
    if (notification) {
        UILabel *dateLabel = (UILabel *) [cell viewWithTag:1];
        UILabel *typeLabel = (UILabel *) [cell viewWithTag:2];
        UILabel *valueLabel = (UILabel *) [cell viewWithTag:3];

        [dateLabel setFont:[GLUCAppearanceController defaultFontOfSize:([UIFont systemFontSize] - 3.0f)]];
        [valueLabel setFont:[GLUCAppearanceController defaultBoldFontOfSize:([UIFont systemFontSize] - 2.0f)]];
        [typeLabel setFont:[GLUCAppearanceController defaultBoldFontOfSize:([UIFont systemFontSize] - 2.0f)]];

        dateLabel.text = [NSString stringWithFormat:@"%@",
                        [NSDateFormatter localizedStringFromDate:[notification fireDate]
                                                       dateStyle:NSDateFormatterShortStyle
                                                       timeStyle:NSDateFormatterShortStyle]];
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo) {
            typeLabel.text = notification.alertTitle;
            valueLabel.text = userInfo[kGLUCScheduleNotificationReadingTypeKey];
        }
        
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void) scheduleReadingOfSelectedType:(Class)readingType {
    
    NSString *readingTypeName = GLUCLoc(@"Not specified");
    UILocalNotification *reminder = [[UILocalNotification alloc] init];
    
    if ([readingType isSubclassOfClass:[GLUCReading class]]) {
        readingTypeName = [readingType title];
    }
    
    if (reminder) {
        // TODO: review for whether this is a sensible default
        //  - to repeat daily at this time
        reminder.fireDate = [[NSCalendar currentCalendar] gluc_dateByAddingDays:1 toDate:[NSDate date]];
        reminder.userInfo = @{
                              kGLUCScheduleNotificationReadingTypeKey : readingTypeName
                              };
        reminder.alertTitle = GLUCLoc(@"Measurement reminder");
        reminder.alertBody = [NSString stringWithFormat:GLUCLoc(@"for type: %@"), readingTypeName];
        reminder.repeatInterval = NSCalendarUnitDay;
        reminder.repeatCalendar = [NSCalendar currentCalendar];
        
        [self.notificationModel scheduleLocalNotification:reminder];
    }
    
    self.notifications =  self.notificationModel.scheduledLocalNotifications;

    [self.notificationTableView reloadData];
    
    if (reminder) {
        [self editEvent:reminder];
    }
    
}

- (IBAction)add:(id)sender { // Add a new scheduled notification
    NSArray *readingTypes = self.notificationTypes;
    
    UIAlertController *readingTypeSelector = [UIAlertController alertControllerWithTitle:GLUCLoc(@"Measurement reminder")
                                                                                 message:GLUCLoc(@"Select a reading type")
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (Class readingType in readingTypes) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:[readingType title] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self scheduleReadingOfSelectedType:readingType];
        }];
        [readingTypeSelector addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:GLUCLoc(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES
                                 completion:NULL];
    }];
    [readingTypeSelector addAction:cancelAction];
    [self presentViewController:readingTypeSelector animated:YES completion:NULL];
}

@end
