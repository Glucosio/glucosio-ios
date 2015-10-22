#import "GLUCAppDelegate.h"
#import "UIColor+GLUCAdditions.h"
#import "GLUCReadingEditorViewController.h"
#import "NSCalendar+GLUCAdditions.h"
#import "GLUCListEditorViewController.h"
#import "GLUCDateTimeEditorViewController.h"
#import "GLUCAppearanceController.h"

@interface GLUCReadingEditorViewController ()
@property (strong, nonatomic) NSArray *rowKeys;
@property (strong, nonatomic) NSArray *values;
@property (assign, nonatomic) BOOL useEditedValue;
@end

@implementation GLUCReadingEditorViewController {

}


@dynamic editedObject;


- (void) viewDidLoad {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    if (!self.model) {
        self.model = [(GLUCAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];
    }
    
    self.rowKeys = @[GLUCLoc(@"Date"), GLUCLoc(@"Time"), GLUCLoc(@"Measured")];
    self.values = @[@"", @"", @""];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    self.useEditedValue = NO;
    
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.valueField setFont:[GLUCAppearanceController valueEditorTextFieldFont]];
    [self.valueField setTextColor:[UIColor gluc_pink]];

    NSDate *editDate = [NSDate date];
    if (self.editedObject) {
        editDate = [self.editedObject creationDate];
        if ([self.editedObject.value integerValue] != 0) {
            NSString *valueStr = (self.model.currentUser.needsUnitConversion) ? [self.numberFormatter stringFromNumber:[self.model.currentUser readingValueInPreferredUnits:self.editedObject]] :
                    [NSString stringWithFormat:@"%@", [self.model.currentUser readingValueInPreferredUnits:self.editedObject]];

            self.valueField.text = valueStr;
        } else {
            self.valueField.text = @"";
        }
    } else {
        self.valueField.text = @"";
    }
    
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    NSString *editDateString = [self.dateFormatter stringFromDate:editDate];

    self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *editTimeString = [self.dateFormatter stringFromDate:editDate];

    NSString *measurementType = @"";
    if (self.editedObject && [self.editedObject.glucId integerValue] == -1 && !self.useEditedValue) {
        NSInteger currentHour = [[NSCalendar currentCalendar] gluc_hourFromDate:editDate];
        measurementType = [self.editedObject readingTypeForId:[self.editedObject readingTypeIdForHourOfDay:currentHour]];
    } else {
        measurementType = [self.editedObject displayValueForKey:kGLUCReadingReadingTypeIdPropertyKey];
    }

    self.values = @[editDateString, editTimeString, measurementType];

    [self.editorTableView reloadData];
    
    [self.valueField becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowKeys.count;
}

- (void) editCreationDate:(BOOL)editTime {
    NSString *targetKey = kGLUCModelCreationDateKey;
    NSString *editorTitle = (editTime) ? GLUCLoc(@"Time") : GLUCLoc(@"Date");
    GLUCDateTimeEditorViewController *editor = (GLUCDateTimeEditorViewController *)[[UIStoryboard storyboardWithName:kGLUCSettingsStoryboardIdentifier bundle:nil] instantiateViewControllerWithIdentifier:@"DateTimeEditor"];
    UIView *v = [editor view]; // force load from xib
    if (v) {
        editor.editedObject = self.editedObject;
        editor.editedProperty = targetKey;
        
        editor.title = [self.editedObject titleForKey:targetKey] ? : editorTitle;
        editor.model = self.model;
        editor.pickerView.datePickerMode = editTime ? UIDatePickerModeTime : UIDatePickerModeDate;
        editor.editedDate = [self.editedObject valueForKey:targetKey];
    }
    
    self.navigationItem.backBarButtonItem = [self cancelButtonItem];
    [self.navigationController pushViewController:editor animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self.valueField resignFirstResponder];
    [self.valueField setFont:[GLUCAppearanceController valueEditorTextFieldFont]];
    [self.model.currentUser setNewValue:@([self.valueField.text floatValue]) inReading:self.editedObject];
    self.useEditedValue = YES;
    
    switch (indexPath.row) {
        case 0:
            [self editCreationDate:NO];
            break;
        case 1:
            [self editCreationDate:YES];
            break;
        case 2: {
            NSString *targetKey = kGLUCReadingReadingTypeIdPropertyKey;
            GLUCListEditorViewController *editor = 
                    (GLUCListEditorViewController *) [[UIStoryboard storyboardWithName:kGLUCSettingsStoryboardIdentifier bundle:nil] instantiateViewControllerWithIdentifier:kGLUCListEditorViewControllerIdentifier];
            editor.editedObject = self.editedObject;
            editor.editedProperty = targetKey;
            editor.title = [self.editedObject titleForKey:targetKey];
            editor.model = self.model;
            
            if ([self.editedObject propertyIsIndirectLookup:targetKey]) {
                NSString *currentValue = [self.editedObject displayValueForKey:targetKey];
                editor.items = [[self.editedObject potentialDisplayValuesForKey:targetKey] sortedArrayUsingSelector:@selector(compare:)];
                editor.selectedItemIndex = [editor.items indexOfObject:currentValue];
            } else {
                editor.items = [self.editedObject potentialDisplayValuesForKey:targetKey];
                editor.selectedItemIndex = [[self.editedObject lookupIndexForKey:targetKey] unsignedIntegerValue];
            }
            
            self.navigationItem.backBarButtonItem = [self cancelButtonItem];
            [self.navigationController pushViewController:editor animated:YES];

            break;
        }
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kGLUCReadingEditorTableViewCellIdentifier];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGLUCReadingEditorTableViewCellIdentifier];
    }
    
    if (indexPath.row >= 0 && indexPath.row < self.rowKeys.count) {
        cell.textLabel.text = self.rowKeys[(NSUInteger) indexPath.row];
        cell.detailTextLabel.text = self.values[(NSUInteger) indexPath.row];
        cell.textLabel.font = [GLUCAppearanceController defaultFont];
        cell.detailTextLabel.font = [GLUCAppearanceController defaultFont];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(UIButton *)sender {
    [self.model.currentUser setNewValue:@([self.valueField.text floatValue]) inReading:self.editedObject];
    [self.model saveReading:self.editedObject];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end