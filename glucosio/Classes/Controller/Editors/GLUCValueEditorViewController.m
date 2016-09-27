#import <Realm/RLMRealm.h>
#import "GLUCValueEditorViewController.h"
#import "GLUCAppearanceController.h"
#import "UIColor+GLUCAdditions.h"

@implementation GLUCValueEditorViewController {

}

- (void) enableOrDisableSaveButton:(NSString *)forValue {
    NSNumber *intVal = @([forValue intValue]);
    self.saveButton.enabled = [self.editedObject validateValue:&intVal forKey:self.editedProperty error:NULL];
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.textField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField setFont:[GLUCAppearanceController valueEditorTextFieldFont]];
    [self.textField setTextColor:[UIColor glucosio_pink]];

    
    NSString *currentValue = [self.editedObject displayValueForKey:self.editedProperty];
    
    [self enableOrDisableSaveButton:currentValue];
    
    if (self.textField) {
        self.textField.text = currentValue;
        self.textField.delegate = self;
        
        [self.textField becomeFirstResponder];
    }
    
}

- (IBAction) textChanged:(UITextField *)sender {
    [self enableOrDisableSaveButton:sender.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self enableOrDisableSaveButton:textField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL retVal = YES;

    [self enableOrDisableSaveButton:[textField.text stringByReplacingCharactersInRange:range withString:string]];

    return retVal;
}

- (IBAction) save:(UIButton *)sender {
    NSNumber *newVal = @([self.textField.text integerValue]);
    
    if (newVal) {
        if (self.editedProperty && self.editedProperty.length && self.editedObject) {
            [[self.editedObject realm] beginWriteTransaction];
            [self.editedObject setValue:newVal forKey:self.editedProperty];
            [[self.editedObject realm] commitWriteTransaction];
        }
    }
    
    [super save:sender];
}

@end