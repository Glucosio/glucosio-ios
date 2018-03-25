//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import "GLUCBloodPressureReading.h"


@implementation GLUCBloodPressureReading {

}

+ (NSString *)title {
    return GLUCLoc(@"Blood Pressure");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_BloodPressure";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_pressure];
}

+ (NSDictionary *)schema {
    NSDictionary *propertiesDict = @{
                                     kGLUCReadingModelValuePropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCReadingModelValuePropertyKey,
                                             kGLUCModelAttributeTitleKey : @"dialog_add_concentration",
                                             kGLUCModelAttributeTypeKey : @"NSNumber",
                                             },
                                     kGLUCReadingDiastolicBloodPressureReadingPropertyKey : @{
                                             kGLUCModelAttributeKey : kGLUCReadingDiastolicBloodPressureReadingPropertyKey,
                                             kGLUCModelAttributeTitleKey : @"Diastolic",
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
             
             kGLUCModelEditorRowsPropertiesKey : @[kGLUCReadingDiastolicBloodPressureReadingPropertyKey, kGLUCModelCreationDatePropertyKey, kGLUCModelCreationTimePropertyKey, kGLUCReadingNotesPropertyKey],
             
             };
}

@end
