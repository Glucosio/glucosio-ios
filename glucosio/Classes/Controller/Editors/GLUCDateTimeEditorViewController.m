#import <Realm/RLMRealm.h>
#import "GLUCDateTimeEditorViewController.h"

@implementation GLUCDateTimeEditorViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pickerView.calendar = [NSCalendar currentCalendar];
    self.editedDate = [NSDate date];
    [self.pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.leftBarButtonItem = [self cancelButtonItem];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.editedDate = [self.editedObject valueForKey:self.editedProperty];
    self.pickerView.date = self.editedDate;
}

- (void) dateChanged:(id) sender {
    self.editedDate = [self.pickerView date];
}

- (IBAction)save:(UIButton *)sender {
    if (self.editedObject) {
        [[self.editedObject realm] beginWriteTransaction];
        [self.editedObject setValue:self.editedDate forKey:self.editedProperty];
        [[self.editedObject realm] commitWriteTransaction];
    }
    
    [super save:sender];
}

@end
