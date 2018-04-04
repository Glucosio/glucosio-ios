//
//  GLUCNightscoutSettingsViewController.m
//  glucosio
//
//  Created by Chris Walters on 2/16/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCNightscoutSettingsViewController.h"
#import "GLUCAppearanceController.h"
#import "GLUCDataServiceNightscout.h"
#import <XLForm/XLForm.h>

@interface GLUCNightscoutSettingsViewController ()
@property (nonatomic, readwrite, strong) NSArray *settingKeys;
@property (nonatomic, readwrite, strong) GLUCDataServiceNightscout *nightscoutService;
@end

@implementation GLUCNightscoutSettingsViewController

- (void)initializeForm {
    if (!self.nightscoutService) {
        self.nightscoutService = [GLUCDataServiceNightscout objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:@"Nightscout"];
    }

    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:GLUCLoc(@"nightscout_settings")];
    
    // First section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"enabled" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Enable Nightscout"];
    row.value = self.nightscoutService.serviceEnabled;
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"uri" rowType:XLFormRowDescriptorTypeURL];
    [row.cellConfigAtConfigure setObject:@"Site URL, https://..." forKey:@"textField.placeholder"];
    row.value = self.nightscoutService.uri;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"secretKey" rowType:XLFormRowDescriptorTypeURL];
    [row.cellConfigAtConfigure setObject:@"Secret Key" forKey:@"textField.placeholder"];
    row.value = self.nightscoutService.secretKey;
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"roleToken" rowType:XLFormRowDescriptorTypeURL];
    [row.cellConfigAtConfigure setObject:@"Role Token" forKey:@"textField.placeholder"];
    row.value = self.nightscoutService.roleToken;
    [section addFormRow:row];

    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = GLUCLoc(@"nightscout_settings");

    self.navigationItem.leftBarButtonItem = [GLUCAppearanceController backButtonItemWithTarget:self action:@selector(back)];

}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeForm];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSString *) stringFromDict:(NSDictionary *)dict forKey:(NSString *)key {
    id result = dict[key];
    if (result == [NSNull null]) {
        result = nil;
    } else {
        result = (NSString *) result;
    }
    return result;
}

- (void) viewWillDisappear:(BOOL)animated {
    NSDictionary *formValues = [self.form formValues];

    [[RLMRealm defaultRealm] beginWriteTransaction];
    if (formValues) {
        [self.nightscoutService setServiceEnabled:[NSNumber numberWithBool:[formValues[@"enabled"] boolValue]]];
        [self.nightscoutService setUri:[self stringFromDict:formValues forKey:@"uri"]];
        [self.nightscoutService setSecretKey:[self stringFromDict:formValues forKey:@"secretKey"]];
        [self.nightscoutService setRoleToken:[self stringFromDict:formValues forKey:@"roleToken"]];
    }
    
    [[RLMRealm defaultRealm] addOrUpdateObject:self.nightscoutService];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
