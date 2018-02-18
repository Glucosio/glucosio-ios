//
//  GLUCNotesEditorViewController.m
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import <Realm/RLMRealm.h>
#import "GLUCNotesEditorViewController.h"
#import "GLUCLoc.h"
#import "GLUCAppearanceController.h"


@interface GLUCNotesEditorViewController ()

@end

@implementation GLUCNotesEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:GLUCLoc(@"Notes Editor")];
    
    // First section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"notes" rowType:XLFormRowDescriptorTypeTextView title:@"Notes"];
    row.value = [self.editedObject valueForKey:self.editedProperty];
    [section addFormRow:row];
    
    
    self.form = form;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeForm];
    
    self.navigationItem.leftBarButtonItem = [GLUCAppearanceController backButtonItemWithTarget:self action:@selector(back)];
}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSDictionary *formValues = self.formValues;
    
    if (formValues) {
        if (self.editedProperty && self.editedProperty.length) {
            [[self.editedObject realm] beginWriteTransaction];
            [self.editedObject setValue:formValues[@"notes"] forKey:self.editedProperty];
            [[self.editedObject realm] commitWriteTransaction];
        }
    }
}

@end
