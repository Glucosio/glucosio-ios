#import "GLUCHistoryViewController.h"
#import "GLUCAppDelegate.h"
#import "GLUCAppearanceController.h"
#import "GLUCReadingEditorViewController.h"

@interface GLUCHistoryViewController ()
@property (strong, nonatomic) UITableViewRowAction *deleteAction;
@property (strong, nonatomic) UITableViewRowAction *editAction;
@end

@implementation GLUCHistoryViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (!self.model) {
        self.model = [(GLUCAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];
    }
    
    self.deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                           title:GLUCLoc(@"Delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                               [self.model deleteReading:self.readings[(NSUInteger) indexPath.row]];
                                                               self.historyTableView.editing = NO;
                                                               self.readings = [self.model allReadings:NO];
                                                               [self.historyTableView reloadData];
    }];
    
    self.editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                         title:GLUCLoc(@"Edit") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                             self.historyTableView.editing = NO;
                                                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:kGLUCMainStoryboardIdentifier bundle:nil];
                                                             if (mainStoryboard) {
                                                                 GLUCReadingEditorViewController *editorVC = (GLUCReadingEditorViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ReadingEditor"];
                                                                 if (editorVC) {
                                                                     NSString *title = GLUCLoc(@"Edit reading");
                                                                     editorVC.title = [NSString stringWithFormat:@"%@ (%@)", title,
                                                                                       [self.model.currentUser displayValueForKey:kGLUCUserPreferredUnitsPropertyKey]];
                                                                     
                                                                     editorVC.editedObject = self.readings[(NSUInteger) indexPath.row];
                                                                     UINavigationController *editorNavCtrl = [[UINavigationController alloc] initWithRootViewController:editorVC];
                                                                     [self presentViewController:editorNavCtrl animated:YES completion:^{
                                                                     }];
                                                                 }
                                                             }

                                                         }];
    
}

- (void) viewWillAppear:(BOOL)animated {
    self.readings = [self.model allReadings:NO];

    [self.historyTableView reloadData];
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.readings.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (NSArray *) tableView:tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return @[self.deleteAction,self.editAction];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kGLUCHistoryCellIdentifier];
    
    GLUCReading *reading = nil;
    
    if (indexPath.row >= 0 && indexPath.row < self.readings.count) {
        reading = self.readings[(NSUInteger) indexPath.row];
    }
    if (reading) {
        UILabel *dateLabel = (UILabel *) [cell viewWithTag:1];
        UILabel *typeLabel = (UILabel *) [cell viewWithTag:2];
        UILabel *valueLabel = (UILabel *) [cell viewWithTag:3];

        [dateLabel setFont:[GLUCAppearanceController defaultFontOfSize:([UIFont systemFontSize] - 3.0f)]];
        [valueLabel setFont:[GLUCAppearanceController defaultBoldFontOfSize:([UIFont systemFontSize] - 2.0f)]];
        [typeLabel setFont:[GLUCAppearanceController defaultBoldFontOfSize:([UIFont systemFontSize] - 2.0f)]];

        dateLabel.text = [NSString stringWithFormat:@"%@",
                        [NSDateFormatter localizedStringFromDate:[reading creationDate]
                                                       dateStyle:NSDateFormatterShortStyle
                                                       timeStyle:NSDateFormatterShortStyle]];
        typeLabel.text = [reading readingType];
        NSString *valueStr = (self.model.currentUser.needsUnitConversion) ?
                [self.numberFormatter stringFromNumber:[self.model.currentUser readingValueInPreferredUnits:reading]] :
                [NSString stringWithFormat:@"%@", [self.model.currentUser readingValueInPreferredUnits:reading]];

        NSString *readingValueStr = [NSString stringWithFormat:@"%@ %@",
                                                           valueStr,
                                                           [self.model.currentUser displayValueForKey:kGLUCUserPreferredUnitsPropertyKey]];;

        valueLabel.text = readingValueStr;
        
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
