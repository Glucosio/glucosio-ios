//
//  GLUCTreatment.m
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCTreatment.h"

@implementation GLUCTreatment

+ (NSString *)title {
    return GLUCLoc(@"Treatment");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_InsulinIntake";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_weight];
}

+ (NSDictionary *)schema {
    NSDictionary *propertiesDict = @{
                                     kGLUCReadingModelValuePropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCReadingModelValuePropertyKey,
                                             kGLUCModelAttributeTitleKey : @"Duration",
                                             kGLUCModelAttributeTypeKey : @"NSNumber",
                                             },
                                     @"treatmentName" : @{
                                             kGLUCModelAttributeKey : @"treatmentName",
                                             kGLUCModelAttributeTitleKey : @"Description",
                                             kGLUCModelAttributeTypeKey : @"NSString",
                                             },
                                     kGLUCReadingNotesPropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCReadingNotesPropertyKey,
                                             kGLUCModelAttributeTitleKey : @"Notes",
                                             kGLUCModelAttributeTypeKey : @"NSString"
                                             },
                                     kGLUCModelCreationDatePropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCModelCreationDateKey,
                                             kGLUCModelAttributeTitleKey : @"dialog_add_date",
                                             kGLUCModelAttributeTypeKey : kGLUCModelAttributeDateTypeKey
                                             },
                                     kGLUCModelCreationTimePropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCModelCreationDateKey,
                                             kGLUCModelAttributeTitleKey : @"dialog_add_time",
                                             kGLUCModelAttributeTypeKey : kGLUCModelAttributeTimeTypeKey
                                             },
                                     
                                     };
    
    return @{
             kGLUCModelSettingsPropertiesKey : @[kGLUCReadingModelValuePropertyKey,
                                                 @"treatmentName",
                                                 kGLUCModelCreationDateKey, kGLUCReadingNotesPropertyKey],
             
             kGLUCModelSchemaPropertiesKey : propertiesDict,
             
             kGLUCModelEditorRowsPropertiesKey : @[@"treatmentName", kGLUCModelCreationDatePropertyKey, kGLUCModelCreationTimePropertyKey, kGLUCReadingNotesPropertyKey],
             
             };
}

@end
