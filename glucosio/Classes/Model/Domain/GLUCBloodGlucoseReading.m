#import <Realm/RLMObject_Private.h>
#import <Realm/RLMRealm_Dynamic.h>
#import <Realm/RLMResults.h>
#import "GLUCBloodGlucoseReading.h"
#import "GLUCLoc.h"
#import "NSCalendar+GLUCAdditions.h"

@implementation GLUCBloodGlucoseReading

+ (NSArray *) readingTypes {
    return @[
             GLUCLoc(@"dialog_add_type_1"), // "Before breakfast"
             GLUCLoc(@"dialog_add_type_2"), // "After breakfast"
             GLUCLoc(@"dialog_add_type_3"), // "Before lunch"
             GLUCLoc(@"dialog_add_type_4"), // "After lunch"
             GLUCLoc(@"dialog_add_type_5"), // "Before dinner"
             GLUCLoc(@"dialog_add_type_6"), // "After dinner"
             GLUCLoc(@"dialog_add_type_7"), // "Snack"
             GLUCLoc(@"dialog_add_type_8"), // "Bedtime"
             GLUCLoc(@"dialog_add_type_9"), // "Night"
             GLUCLoc(@"dialog_add_type_10"), // "Fasting glucose"
             GLUCLoc(@"dialog_add_type_11"), // "Recheck"
             GLUCLoc(@"dialog_add_type_12"), // "Other"
             ];
}

+ (NSDictionary *)schema {
    NSDictionary *propertiesDict = @{
            kGLUCReadingModelValuePropertyKey : @{
                    kGLUCModelAttributeKey : kGLUCReadingModelValuePropertyKey,
                    kGLUCModelAttributeTitleKey : @"dialog_add_concentration",
                    kGLUCModelAttributeTypeKey : @"NSNumber",
            },
            kGLUCReadingReadingTypeIdPropertyKey : @{
                    kGLUCModelAttributeKey : kGLUCReadingReadingTypeIdPropertyKey,
                    kGLUCModelAttributeTitleKey : @"dialog_add_measured",
                    kGLUCModelAttributeTypeKey : @"NSNumber",
                    kGLUCModelPotentialValuesKey : [GLUCBloodGlucoseReading readingTypes],
                    kGLUCModelDefaultIndexKey : @0

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
                    kGLUCModelCreationDateKey,kGLUCReadingReadingTypeIdPropertyKey, kGLUCReadingNotesPropertyKey],

            kGLUCModelSchemaPropertiesKey : propertiesDict,

            kGLUCModelEditorRowsPropertiesKey : @[kGLUCModelCreationDatePropertyKey, kGLUCModelCreationTimePropertyKey, kGLUCReadingReadingTypeIdPropertyKey],

    };
}


+ (NSString *)title {
    return GLUCLoc(@"Blood Glucose Level");
}

- (instancetype) init {
    if ((self = [super init]) != nil) {
        NSInteger rTypeId = [self readingTypeIdForHourOfDay:[[NSCalendar currentCalendar] gluc_hourFromDate:[NSDate date]]];
        self.readingTypeId = (NSNumber <RLMInt> *) @(rTypeId);
    }
    return self;
}

- (instancetype)initWithValue:(id)value {
    self = [super initWithValue:value];
    if (self) {
    }

    return self;
}

- (instancetype)initWithRealm:(__unsafe_unretained RLMRealm *const)realm schema:(__unsafe_unretained RLMObjectSchema *const)schema {
    self = [super initWithRealm:realm schema:schema];
    if (self) {
    }

    return self;
}

+ (NSArray *) averageMonthlyReadings {
    RLMResults<GLUCBloodGlucoseReading *> *allBloodGlucoseReadings = [self allObjects];
    NSMutableArray *averageReadings = [NSMutableArray array];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    df.dateFormat = @"yyyy-MM";

    NSDate *minDate = [cal gluc_firstMinuteOfDayForDate:[cal gluc_firstDayOfMonthForDate:[allBloodGlucoseReadings minOfProperty:@"creationDate"]]];
    NSDate *maxDate = [cal gluc_lastMinuteOfDayForDate:[cal gluc_lastDayOfMonthForDate:[allBloodGlucoseReadings maxOfProperty:@"creationDate"]]];

    NSInteger monthsBetween = [[NSCalendar currentCalendar] gluc_monthsBetween:minDate andDate:maxDate];

    for (NSInteger monthIndex = 0; monthIndex < monthsBetween; ++monthIndex) {
        NSDate *startDate = [cal gluc_dateByAddingMonths:monthIndex toDate:minDate];
        NSDate *endDate = [cal gluc_dateByAddingMonths:1 toDate:startDate];

        RLMResults<GLUCBloodGlucoseReading *> *monthReadings =
                [allBloodGlucoseReadings objectsWhere:@"creationDate BETWEEN {%@, %@}", startDate, endDate];
        if (monthReadings) {
            [averageReadings addObject:@{
                    @"index" : @(monthIndex),
                    @"startDate" : startDate,
                    @"endDate" : endDate,
                    @"title" : [df stringFromDate:startDate],
                    @"numReadings" : @(monthReadings.count),
                    @"average" : [monthReadings averageOfProperty:@"reading"]
            }];
        }
    }

    return [NSArray arrayWithArray:averageReadings];
}

- (NSString *) readingTypeForId:(NSInteger) readingTypeId {
    NSString *retVal = GLUCLoc(@"dialog_add_type_12"); // default is "Other"
    NSArray *types = [[self class] readingTypes];
    if (readingTypeId >= 0 && readingTypeId < types.count)
        retVal = types[(NSUInteger)readingTypeId];
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
