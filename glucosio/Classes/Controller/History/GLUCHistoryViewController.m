#import <Realm/RLMArray.h>
#import "GLUCHistoryViewController.h"
#import "GLUCAppDelegate.h"
#import "GLUCAppearanceController.h"
#import "GLUCReadingEditorViewController.h"
#import "GLUCBloodGlucoseReading.h"
#import "GLUCHBA1CReading.h"
#import "GLUCCholesterolReading.h"
#import "GLUCBloodPressureReading.h"
#import "GLUCKetonesReading.h"
#import "GLUCBodyWeightReading.h"
#import "GLUCInsulinIntakeReading.h"

@interface GLUCHistoryViewController ()
@property (strong, nonatomic) UITableViewRowAction *deleteAction;
@property (strong, nonatomic) UITableViewRowAction *editAction;
@property (strong, nonatomic) NSArray *readingTypes;
@end

@implementation GLUCHistoryViewController

- (void) viewDidLoad {
    [super viewDidLoad];


    if (!self.model) {
        self.model = [(GLUCAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];
    }
    self.readingTypes = [self.model.currentUser readingTypes];
    self.readingClass = self.readingTypes.firstObject;

    self.deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                           title:GLUCLoc(@"dialog_delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                [self.model deleteReading:self.readings[(NSUInteger) indexPath.row]];
                                                               self.historyTableView.editing = NO;

                                                               self.readings = [self.model allReadingsOfType:self.readingClass sortByDateAscending:NO];
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
                                                                             [self.model.currentUser displayValueForReading:self.readings[(NSUInteger)indexPath.row]]];

                                                                     editorVC.editedObject = self.readings[(NSUInteger) indexPath.row];
                                                                     UINavigationController *editorNavCtrl = [[UINavigationController alloc] initWithRootViewController:editorVC];
                                                                     [self presentViewController:editorNavCtrl animated:YES completion:^{
                                                                     }];
                                                                 }
                                                             }

                                                         }];
    
    self.title = GLUCLoc(@"tab_history");

}

- (void) viewWillAppear:(BOOL)animated {
    self.readings = [self.model allReadingsOfType:self.readingClass sortByDateAscending:NO];

    [self.historyTableView reloadData];
    [super viewWillAppear:animated];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.readingTypes.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.readingTypes[row] title];
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.readingClass = self.readingTypes[row];
    self.readings = [self.model allReadingsOfType:self.readingClass sortByDateAscending:NO];

    [self.historyTableView reloadData];
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
        if ([reading respondsToSelector:@selector(readingType)])
            typeLabel.text = [(id)reading readingType];
        else
            typeLabel.text = [self.readingClass title];

        NSString *valueStr = [self.model.currentUser displayValueForReading:reading];
        NSString *unitsStr = [self.model.currentUser displayUnitsForReading:reading];
        NSString *readingValueStr = [NSString stringWithFormat:@"%@ %@", valueStr, unitsStr];

        valueLabel.text = readingValueStr;
        
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
