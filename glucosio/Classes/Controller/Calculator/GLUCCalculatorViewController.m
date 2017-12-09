#import "GLUCCalculatorViewController.h"
#import "UIColor+GLUCAdditions.h"
#import "GLUCLoc.h"
#import "GLUCAppearanceController.h"
#import "GLUCAppDelegate.h"
#import "GLUCBloodGlucoseReading.h"
#import "GLUCHbA1cReading.h"
#import "GLUCReadingEditorViewController.h"

@interface GLUCCalculatorViewController()
@property (strong, nonatomic) IBOutlet UIStackView *stackView;

@property (strong, nonatomic) IBOutlet UILabel *inputTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *inputUnitsLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultsTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultsUnitsLabel;
@property (strong, nonatomic) IBOutlet UITextField *inputValueField;
@property (strong, nonatomic) IBOutlet UITextField *resultsValueField;
@end

@implementation GLUCCalculatorViewController

- (UIToolbar *) decimalPadAccessory {
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectZero];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    
    [doneButtonItem setTitleTextAttributes:@{
                                             NSFontAttributeName: [GLUCAppearanceController defaultFont],
                                             NSForegroundColorAttributeName: [UIColor glucosio_pink_dark]
                                             } forState:UIControlStateNormal];
    
    
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            doneButtonItem];
    [numberToolbar sizeToFit];

    return numberToolbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputValueField.text = @"";
    self.resultsValueField.text = @"";
    
    self.inputValueField.inputAccessoryView = [self decimalPadAccessory];
    self.resultsValueField.inputAccessoryView = self.inputValueField.inputAccessoryView;
}


-(void) dismissKeyboard {
    [self.inputValueField resignFirstResponder];
    [self.resultsValueField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.inputValueField setFont:[GLUCAppearanceController valueEditorTextFieldFont]];
    [self.inputUnitsLabel setTextColor:[UIColor glucosio_pink]];
    
    [self.resultsUnitsLabel setTextColor:[UIColor glucosio_pink]];
    [self.resultsValueField setFont:[GLUCAppearanceController valueEditorTextFieldFont]];
    
    self.inputUnitsLabel.text = [self.model.currentUser displayUnitsForBloodGlucoseReadings];
    self.resultsUnitsLabel.text = [self.model.currentUser displayUnitsForHbA1cReadings];
    
    [self recalc];
    
    [self.resultsValueField setNeedsDisplay];
    
    [self.inputValueField becomeFirstResponder];
}


- (void) recalc {
    if (self.inputValueField.text.length) {
        NSNumber *inputGlucoseMgDl = @(self.inputValueField.text.doubleValue);
        if ([self.model.currentUser needsBloodGlucoseReadingUnitConversion]) {
            inputGlucoseMgDl = [GLUCBloodGlucoseReading glucoseToMgDl:inputGlucoseMgDl];
        }
        NSInteger hbA1cUnits = [[self.model.currentUser preferredA1CUnitOfMeasure] integerValue];
        
        NSNumber *hbA1cValue = [GLUCBloodGlucoseReading glucoseToA1CInUnits:hbA1cUnits forValue:inputGlucoseMgDl];
        
        [self.numberFormatter setMaximumFractionDigits:2];
        
        
        self.resultsValueField.text = [self.numberFormatter stringFromNumber:hbA1cValue];
    } else {
        self.resultsValueField.text = @"";
    }
}

- (IBAction) textEditingEnded:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction) textChanged:(UITextField *)sender {
    [self recalc];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self recalc];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return (textField != self.resultsValueField);
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (IBAction) save:(UIButton *)sender {
    // todo
}

- (void) addReadingOfSelectedType:(Class)readingType {
    
}

- (IBAction)add:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:kGLUCMainStoryboardIdentifier bundle:nil];
    if (mainStoryboard) {
        GLUCReadingEditorViewController *editorVC = (GLUCReadingEditorViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:kGLUCReadingEditorViewControllerIdentifier];
        if (editorVC) {
            GLUCHbA1cReading *newReading = [[GLUCHbA1cReading alloc] init];
            NSNumber *newVal = [GLUCHbA1cReading convertValue:@(self.resultsValueField.text.doubleValue) fromUnits:[self.model.currentUser unitPreferenceForReadingType:[newReading class]] toUnits:0];
            newReading.reading = newVal;
            editorVC.title = [NSString stringWithFormat:@"%@ %@", GLUCLoc(@"Add"), GLUCLoc([GLUCHbA1cReading title])];
            editorVC.editedObject = newReading;
            
            UINavigationController *editorNavCtrl = [[UINavigationController alloc] initWithRootViewController:editorVC];
            [self presentViewController:editorNavCtrl animated:YES completion:^{}];
        }
    }
}

@end
