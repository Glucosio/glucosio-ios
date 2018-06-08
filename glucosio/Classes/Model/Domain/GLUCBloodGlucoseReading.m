#import <Realm/RLMObject_Private.h>
#import <Realm/RLMRealm_Dynamic.h>
#import <Realm/RLMResults.h>
#import "GLUCBloodGlucoseReading.h"
#import "GLUCLoc.h"
#import "NSCalendar+GLUCAdditions.h"
#import "GLUCRange.h"

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

// Corresponding HealthKit metadata constants taken from https://github.com/dariosalvi78/cordova-plugin-health/issues/65
// Not sure if they are a standard or not.
- (NSString *) healthKitMealTime {
    switch ([[self readingTypeId] intValue]) {
        case 0:
            return @"before_breakfast";
        case 1:
            return @"after_breakfast";
        case 2:
            return @"before_lunch";
        case 3:
            return @"after_lunch";
        case 4:
            return @"before_dinner";
        case 5:
            return @"after_dinner";
        case 6:
            return @"snack";
        case 7:
            // "Bedtime"
            // TODO: mapping this to after_dinner, a better mapping might exist / appear in the future
            return @"after_dinner";
        case 8:
            // "Night"
            return @"unknown";
        case 9:
            return @"fasting";
        case 10:
            // "Recheck"
            return @"unknown";
        case 11:
            return @"unknown";
        default:
            return @"unknown";
    }
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

            kGLUCModelEditorRowsPropertiesKey : @[kGLUCModelCreationDatePropertyKey, kGLUCModelCreationTimePropertyKey, kGLUCReadingReadingTypeIdPropertyKey, kGLUCReadingNotesPropertyKey],

    };
}


+ (NSString *)title {
    return GLUCLoc(@"Blood Glucose Level");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_Glucose";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_glucose];
}

+ (UIColor *) historyColor: (GLUCReading *) me forUser: (GLUCUser *) user {
    NSDictionary * range = [[GLUCRange allRanges] objectAtIndex:[[user rangeType] intValue]];

    double hypoLimit =[range[@"min"] doubleValue];
    double hyperLimit = [range[@"max"] doubleValue];
    double userMin = user.rangeMin.doubleValue;
    double userMax = user.rangeMax.doubleValue;

    double reading = me.reading.doubleValue;

    if (reading < hypoLimit) {
        return UIColor.glucosio_reading_hypo;
    } else if (reading > hyperLimit) {
        return UIColor.glucosio_reading_hyper;
    } else if (reading < userMin) {
        return UIColor.glucosio_reading_low;
    } else if (reading > userMax) {
        return UIColor.glucosio_reading_high;
    } else {
        return UIColor.glucosio_reading_ok;
    }
}

+ (HKQuantityType *) healthKitQuantityType {
    return [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
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

- (NSDictionary *) dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    NSMutableDictionary *property_dict = [NSMutableDictionary dictionary];
    
    property_dict[kGLUCReadingReadingTypeIdPropertyKey] = self.readingTypeId ?: @-1;
    
    [dict addEntriesFromDictionary:property_dict];
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (RLMResults<GLUCBloodGlucoseReading *> *) last24hReadings {
    RLMResults<GLUCBloodGlucoseReading *> *allBloodGlucoseReadings = [[self allObjects] sortedResultsUsingKeyPath:@"creationDate" ascending:YES];

    NSDate *endDate = [allBloodGlucoseReadings maxOfProperty:@"creationDate"];
    NSDate *startDate = [[NSCalendar currentCalendar] gluc_dateByAddingDays:-1 toDate:endDate];

    RLMResults<GLUCBloodGlucoseReading *> *today = [allBloodGlucoseReadings objectsWhere:@"creationDate BETWEEN {%@, %@}", startDate, endDate];

    return today;
}

+ (NSArray *) averageMonthlyReadings {
    RLMResults<GLUCBloodGlucoseReading *> *allBloodGlucoseReadings = [self allObjects];
    NSMutableArray *averageReadings = [NSMutableArray array];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    df.dateFormat = @"yyyy-MM";

    // Use same date technique for averaging as Glucosio for Android
    NSDate *minDate = [allBloodGlucoseReadings minOfProperty:@"creationDate"];
    NSDate *maxDate = [allBloodGlucoseReadings maxOfProperty:@"creationDate"];

    NSInteger monthsBetween = [[NSCalendar currentCalendar] gluc_monthsBetween:minDate andDate:maxDate];

    for (NSInteger monthIndex = 0; monthIndex < monthsBetween; ++monthIndex) {
        NSDate *startDate = [cal gluc_dateByAddingMonths:monthIndex toDate:minDate];
        NSDate *endDate = [cal gluc_dateByAddingMonths:1 toDate:startDate];

        RLMResults<GLUCBloodGlucoseReading *> *monthReadings =
                [allBloodGlucoseReadings objectsWhere:@"creationDate BETWEEN {%@, %@}", startDate, endDate];
        if (monthReadings && monthReadings.count) {
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


+ (NSNumber *) glucoseToMgDl:(NSNumber *) mmolL_glucose {
    return [NSNumber numberWithDouble:[mmolL_glucose doubleValue] * 18.0f];
}

+ (NSNumber *) glucoseToMmolL:(NSNumber *) mgDl_glucose {
    return [NSNumber numberWithDouble:[mgDl_glucose doubleValue] / 18.0f];
}

+ (NSNumber *) glucoseToA1CAsPercentage:(NSNumber *)mgDl_glucose {
    NSNumber *h1bacValue = @(0);
    if (mgDl_glucose) {
        h1bacValue = @(([mgDl_glucose doubleValue] + 46.7) / 28.7);
    }
    return h1bacValue;
}

+ (NSNumber *)glucoseToA1CAsMmolMol:(NSNumber *)mgDl_glucose {
    double glucToA1C = [[self glucoseToA1CAsPercentage:mgDl_glucose] doubleValue];
    return @((glucToA1C - 2.152) / 0.09148);
}

+ (NSNumber *) glucoseToA1CInUnits:(NSInteger)units forValue:(NSNumber *)value {
    if (units == 0) {
        return [self glucoseToA1CAsPercentage:value];
    } else {
        return [self glucoseToA1CAsMmolMol:value];
    }
}

+ (NSNumber *) convertValue:(NSNumber *)aValue fromUnits:(NSInteger)fromUnits toUnits:(NSInteger)toUnits {
    NSNumber *retVal = aValue;
    if (fromUnits != toUnits) {
        if (fromUnits == 0 && toUnits == 1) {
            retVal = [self glucoseToMmolL:aValue];
        }
        if (fromUnits == 1 && toUnits == 0) {
            retVal = [self glucoseToMgDl:aValue];
        }
    }
    return retVal;
}


// units = 0 is always the default units for the reading
- (NSNumber *) readingInUnits:(NSInteger)units {
    return [[self class] convertValue:self.reading fromUnits:0 toUnits:units];
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
