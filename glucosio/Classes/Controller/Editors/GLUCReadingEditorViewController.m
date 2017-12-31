#import <Realm/RLMRealm.h>
#import "GLUCAppDelegate.h"
#import "UIColor+GLUCAdditions.h"
#import "GLUCReadingEditorViewController.h"
#import "NSCalendar+GLUCAdditions.h"
#import "GLUCListEditorViewController.h"
#import "GLUCDateTimeEditorViewController.h"
#import "GLUCAppearanceController.h"
#import "GLUCValueEditorViewController.h"
#import "TimelineUtil.h"
#import "glucosio-Swift.h"

@interface GLUCReadingEditorViewController ()
@property (strong, nonatomic) NSArray *rowKeys;
@property (assign, nonatomic) BOOL useEditedValue;
@end

@implementation GLUCReadingEditorViewController {

}


@dynamic editedObject;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // If you leve it enabled a white space of 44px height will appear above the tableview (the same space occupied by a navigation bar)
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.editorTableView.tableFooterView = [[UIView alloc] init];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    self.rowKeys = [self rowKeysForReadingType:self.editedObject.class];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    self.useEditedValue = NO;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.valueField setFont:[GLUCAppearanceController valueEditorTextFieldFont]];
    [self.valueField setTextColor:[UIColor glucosio_pink]];

    GLUCReading *editedReading = (GLUCReading *)self.editedObject;
    if (editedReading) {
        self.unitsLabel.text = [self.model.currentUser displayUnitsForReading:editedReading];
        if ([editedReading.reading integerValue] != 0) {
            NSString *valueStr = [self.model.currentUser displayValueForReading:editedReading];

            self.valueField.text = valueStr;
            
        } else {
            self.valueField.text = @"";
        }
    } else {
        self.unitsLabel.text = @"";
        self.valueField.text = @"";
    }

    [self.editorTableView reloadData];
    
    [self.valueField becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowKeys.count;
}

- (void) editCreationDate:(BOOL)editTime {
    NSString *targetKey = kGLUCModelCreationDateKey;
    NSString *editorTitle = (editTime) ? GLUCLoc(@"dialog_add_time") : GLUCLoc(@"dialog_add_date");
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
    [self.model.currentUser setNewValue:@([self.valueField.text floatValue]) inReading:(GLUCReading *)self.editedObject];
    self.useEditedValue = YES;
    
    NSString *targetKey = self.rowKeys[indexPath.row];
    
    if ([self.editedObject isDateKey:targetKey] || [self.editedObject isTimeKey:targetKey]) {
        [self editCreationDate:[self.editedObject isTimeKey:self.rowKeys[indexPath.row]]];
    } else {
        if ([self.editedObject propertyIsLookup:targetKey] || [self.editedObject propertyIsIndirectLookup:targetKey]) {
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
        } else {
            GLUCValueEditorViewController *editor = (GLUCValueEditorViewController *)[[UIStoryboard storyboardWithName:kGLUCSettingsStoryboardIdentifier bundle:nil] instantiateViewControllerWithIdentifier:kGLUCValueEditorViewControllerIdentifier];
            editor.editedObject = self.editedObject;
            editor.editedProperty = targetKey;
            editor.title = [self.model.currentUser titleForKey:targetKey];
            editor.model = self.model;
            self.navigationItem.backBarButtonItem = [self cancelButtonItem];
            [self.navigationController pushViewController:editor animated:YES];

        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kGLUCReadingEditorTableViewCellIdentifier];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGLUCReadingEditorTableViewCellIdentifier];
    }
    
    if (indexPath.row >= 0 && indexPath.row < self.rowKeys.count) {
        cell.textLabel.text = [self titleForRowWithKey:self.rowKeys[(NSUInteger)indexPath.row]];
        cell.detailTextLabel.text = [self displayValueForRowWithKey:self.rowKeys[(NSUInteger)indexPath.row]];
        cell.textLabel.font = [GLUCAppearanceController defaultFont];
        cell.detailTextLabel.font = [GLUCAppearanceController defaultFont];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}



- (NSString *)displayValueForRowWithKey:(NSString *)key {
    NSString *retVal = @"???";
    NSDictionary *schema = [self.editedObject.class schema];
    if (schema) {
        if ([self.editedObject isDateKey:key]) {
            self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
            self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
            retVal = [self.editedObject displayValueForDateKey:schema[kGLUCModelSchemaPropertiesKey][key][kGLUCModelAttributeKey] withDateFormatter:self.dateFormatter];
        } else {
            if ([self.editedObject isTimeKey:key]) {
                self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
                self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
                retVal = [self.editedObject displayValueForDateKey:schema[kGLUCModelSchemaPropertiesKey][key][kGLUCModelAttributeKey] withDateFormatter:self.dateFormatter];
            } else {
                retVal = [self.editedObject displayValueForKey:schema[kGLUCModelSchemaPropertiesKey][key][kGLUCModelAttributeKey]];
            }
        }

    }

    return retVal;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (IBAction)cancel:(id)sender {
    [self.valueField resignFirstResponder];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(UIButton *)sender {
    [self.valueField resignFirstResponder];
    [self.model.currentUser setNewValue:@([self.valueField.text floatValue]) inReading:(GLUCReading *)self.editedObject];
    [self.model saveReading:(GLUCReading *)self.editedObject];

    //TODO: push more reading types to the watch
    //EMI: Can't use .class directly since these are all Realm proxies. Note how RLMObject.class.className does have the actual proxied class name.
    if ([self.editedObject.class isSubclassOfClass:[GLUCBloodGlucoseReading class]]) {
        NSDictionary * context = [[TimelineUtil load24hTimeline: self.model.currentUser] toDictionary];
        [WCSession.defaultSession updateApplicationContext:context error:nil];

        GLUCBloodGlucoseReading * gReading = (GLUCBloodGlucoseReading *) self.editedObject;

        double mgdL =[[gReading readingInUnits:0 /* mg/dL, see preferredBloodGlucoseUnitOfMeasure*/ ] doubleValue];

        [HealthKitBridge.singleton addMolarMassBloodGlucoseWithValue: mgdL
                                                                when: gReading.creationDate
                                                            mealTime: gReading.healthKitMealTime];
    }

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
