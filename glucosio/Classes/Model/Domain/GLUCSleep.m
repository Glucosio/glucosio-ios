//
//  GLUCSleep.m
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCSleep.h"

@implementation GLUCSleep

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sleepApneaEventsPerHour = @0;
        self.cpapMaskScore = @0;
        self.cpapMaskEventCount = @0;
    }
    
    return self;
}

+ (NSString *)title {
    return GLUCLoc(@"Sleep");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_Sleep";
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
                                             kGLUCModelAttributeTitleKey : @"Sleep type",
                                             kGLUCModelAttributeTypeKey : @"NSString",
                                             },
                                     @"sleepApneaEventsPerHour" : @{
                                             kGLUCModelAttributeKey : @"sleepApneaEventsPerHour",
                                             kGLUCModelAttributeTitleKey : @"CPAP Events/hr",
                                             kGLUCModelAttributeTypeKey : @"NSNumber",
                                             },
                                     @"cpapMaskScore" : @{
                                             kGLUCModelAttributeKey : @"cpapMaskScore",
                                             kGLUCModelAttributeTitleKey : @"CPAP Mask Score",
                                             kGLUCModelAttributeTypeKey : @"NSNumber",
                                             },
                                     @"cpapMaskEventCount" : @{
                                             kGLUCModelAttributeKey : @"cpapMaskEventCount",
                                             kGLUCModelAttributeTitleKey : @"CPAP Mask Events (on/off)",
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
                                                 @"duration",
                                                 @"sleepApneaEventsPerHour",
                                                 @"cpapMaskScore",
                                                 @"cpapMaskEventCount",
                                                 kGLUCModelCreationDateKey,
                                                 kGLUCReadingNotesPropertyKey],
             
             kGLUCModelSchemaPropertiesKey : propertiesDict,
             
             kGLUCModelEditorRowsPropertiesKey :@[
                     kGLUCReadingModelValuePropertyKey,
                     @"sleepApneaEventsPerHour",
                     @"cpapMaskScore",
                     @"cpapMaskEventCount",
                     kGLUCModelCreationDatePropertyKey,
                     kGLUCModelCreationTimePropertyKey,
                     kGLUCReadingNotesPropertyKey],
             
             };
}

@end
