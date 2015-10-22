#import "GLUCReading.h"
#import "GLUCLoc.h"

@implementation GLUCReading

+ (NSArray *) readingTypes {
    return @[
             GLUCLoc(@"Before breakfast"),
             GLUCLoc(@"After breakfast"),
             GLUCLoc(@"Before lunch"),
             GLUCLoc(@"After lunch"),
             GLUCLoc(@"Before dinner"),
             GLUCLoc(@"After dinner"),
             GLUCLoc(@"General"),
             GLUCLoc(@"Recheck"),
             GLUCLoc(@"Night"),
             GLUCLoc(@"Other"),
             ];
}

- (void)setupDefaultData {
    self.schema = @{
            kGLUCModelSettingsPropertiesKey : @[kGLUCReadingModelValuePropertyKey, 
                    kGLUCModelCreationDateKey,kGLUCReadingReadingTypeIdPropertyKey, kGLUCReadingNotesPropertyKey, kGLUCReadingModelCustomTypeNamePropertyKey],

            kGLUCModelSchemaPropertiesKey : @{
                    kGLUCReadingModelValuePropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCReadingModelValuePropertyKey,
                            kGLUCModelAttributeTitleKey : @"Value",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                    },
                    kGLUCReadingReadingTypeIdPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCReadingReadingTypeIdPropertyKey,
                            kGLUCModelAttributeTitleKey : @"Measured",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelPotentialValuesKey : [GLUCReading readingTypes],
                            kGLUCModelDefaultIndexKey : @0

                    },
                    kGLUCReadingNotesPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCReadingNotesPropertyKey,
                            kGLUCModelAttributeTitleKey : @"Notes",
                            kGLUCModelAttributeTypeKey : @"NSString"
                    },
                    kGLUCReadingModelCustomTypeNamePropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCReadingModelCustomTypeNamePropertyKey,
                            kGLUCModelAttributeTitleKey : @"Custom measure",
                            kGLUCModelAttributeTypeKey : @"NSString"

                    }
            }
    };

}

- (instancetype) init {
    if ((self = [super init]) != nil) {
        [self setupDefaultData];

        self.creationDate = [NSDate date];
        self.modificationDate = self.creationDate;
        self.glucId = @(-1);
    }
    return self;
}

- (NSString *) readingTypeForId:(NSInteger) readingTypeId {
    NSString *retVal = GLUCLoc(@"Other");
    NSArray *types = [[self class] readingTypes];
    if (readingTypeId >= 0 && readingTypeId < types.count)
        retVal = types[readingTypeId];
    return retVal;
}

- (NSString *) readingType {
    return [self readingTypeForId:[self.readingTypeId integerValue]];
}

- (NSInteger) readingTypeIdForHourOfDay:(NSInteger)hour {
    NSInteger retVal = -1; // other
    
    if (hour > 23) {
        retVal = 8;  //night
    } else if (hour > 20) {
        retVal = 5; //after dinner
    } else if (hour > 17) {
        retVal = 4; // before dinner
    } else if (hour > 13) {
        retVal = 3; // after lunch
    } else if (hour > 11) {
        retVal = 2; // before lunch
    } else if (hour > 7) {
        retVal = 1; //after breakfast
    } else if (hour > 4) {
        retVal = 0; // before breakfast
    } else {
        retVal = -1; // other
    }
    
    return retVal;
}

@end
