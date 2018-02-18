//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import "GLUCCholesterolReading.h"


@implementation GLUCCholesterolReading {

}

+ (NSString *)title {
    return GLUCLoc(@"Cholesterol Level");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_Cholesterol";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_cholesterol];
}

+ (NSDictionary *)schema {
    NSDictionary *propertiesDict = @{
                                     kGLUCReadingModelValuePropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCReadingModelValuePropertyKey,
                                             kGLUCModelAttributeTitleKey : @"dialog_add_concentration",
                                             kGLUCModelAttributeTypeKey : @"NSNumber",
                                             },
                                     kGLUCReadingLDLReadingPropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCReadingLDLReadingPropertyKey,
                                             kGLUCModelAttributeTitleKey : @"LDL Reading",
                                             kGLUCModelAttributeTypeKey : @"NSNumber",
                                             },
                                     kGLUCReadingHDLReadingPropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCReadingHDLReadingPropertyKey,
                                             kGLUCModelAttributeTitleKey : @"HDL Reading",
                                             kGLUCModelAttributeTypeKey : @"NSNumber",
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
                                                 kGLUCModelCreationDateKey, kGLUCReadingNotesPropertyKey],
             
             kGLUCModelSchemaPropertiesKey : propertiesDict,
             
             kGLUCModelEditorRowsPropertiesKey : @[kGLUCReadingLDLReadingPropertyKey, kGLUCReadingHDLReadingPropertyKey, kGLUCModelCreationDatePropertyKey, kGLUCModelCreationTimePropertyKey, kGLUCReadingNotesPropertyKey],
             
             };
}

@end
