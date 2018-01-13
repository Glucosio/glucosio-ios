#import "GLUCListEditorViewController.h"
#import "UIColor+GLUCAdditions.h"
#import "GLUCLoc.h"
#import "GLUCEditorViewController.h"

@implementation GLUCListEditorViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [self cancelButtonItem];

    [self.pickerView reloadAllComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pickerView selectRow:self.selectedItemIndex inComponent:0 animated:NO];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (!self.pickerView) {
        self.pickerView = pickerView;
    }
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.items.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *retVal = @"";

    if (row >= 0 && row < self.items.count) {
        retVal = self.items[(NSUInteger)row];
    }

    return retVal;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedItemIndex = (NSUInteger)row;
}

- (IBAction)save:(UIButton *)sender {
    if (self.editedObject) {
        if ([self.editedObject propertyIsIndirectLookup:self.editedProperty]) {
            NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
            if (selectedRow >= 0 && selectedRow < self.items.count) {
                NSString *selectedValue = self.items[(NSUInteger) selectedRow];

                if (selectedValue && selectedValue.length) {
                    NSNumber *lookupIndex = [self.editedObject lookupIndexFromDisplayValue:selectedValue forKey:self.editedProperty];
                    if (lookupIndex) {
                        [self.editedObject setValueFromLookupAtIndex:lookupIndex forKey:self.editedProperty];
                    }
                }
            }
        } else {
            [self.editedObject setValueFromLookupAtIndex:@(self.selectedItemIndex) forKey:self.editedProperty];
        }
    }
    
    [super save:sender];
}

@end
