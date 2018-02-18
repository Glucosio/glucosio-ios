#import <Realm/Realm.h>
#import "GLUCUser.h"
#import "GLUCRange.h"
#import "GLUCReading.h"
#import "GLUCBloodGlucoseReading.h"
#import "GLUCHbA1cReading.h"
#import "GLUCCholesterolReading.h"
#import "GLUCBloodPressureReading.h"
#import "GLUCKetonesReading.h"
#import "GLUCBodyWeightReading.h"
#import "GLUCInsulinIntakeReading.h"
#import "GLUCTreatment.h"
#import "GLUCMedication.h"
#import "GLUCSleep.h"
#import "GLUCExercise.h"
#import "GLUCFood.h"

@interface GLUCUser ()
@end

@implementation GLUCUser

+ (NSString *)title {
    return GLUCLoc(@"User");
}

+ (NSDictionary *)schema {
    return @{
            kGLUCModelSettingsPropertiesKey : @[kGLUCUserCountryPreferenceKey, kGLUCUserAgePropertyKey,
                    kGLUCUserGenderPropertyKey, kGLUCUserIllnessTypePropertyKey, kGLUCUserPreferredBloodGlucoseUnitsPropertyKey,
                    kGLUCUserPreferredBodyWeightUnitsPropertyKey, kGLUCUserPreferredA1CUnitsPropertyKey,
                    kGLUCUserRangeTypePropertyKey, kGLUCUserRangeMinPropertyKey, kGLUCUserRangeMaxPropertyKey, kGLUCUserAllowResearchUsePropertyKey],

            kGLUCModelRequiredStartPropertiesKey : @[kGLUCUserCountryPreferenceKey, kGLUCUserAgePropertyKey,
                    kGLUCUserGenderPropertyKey, kGLUCUserIllnessTypePropertyKey, kGLUCUserPreferredBloodGlucoseUnitsPropertyKey,
                    kGLUCUserPreferredBodyWeightUnitsPropertyKey, kGLUCUserPreferredA1CUnitsPropertyKey,
                    kGLUCUserAllowResearchUsePropertyKey],

            kGLUCModelSchemaPropertiesKey : @{
                    kGLUCUserCountryPreferenceKey : @{
                            kGLUCModelAttributeKey : kGLUCUserCountryPreferenceKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_country",
                            kGLUCModelAttributeTypeKey : @"NSString",
                            kGLUCModelPotentialValuesKey : [NSLocale ISOCountryCodes],
                            kGLUCModelDefaultValueKey : [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode],
                            kGLUCModelDefaultIndexKey : @([[NSLocale ISOCountryCodes] indexOfObject:[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]]),
                    },
                    kGLUCUserAgePropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserAgePropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_age",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelAttributeValidRangeKey : @{
                                    @"min" : @2,
                                    @"max" : @120
                            },
                    },
                    kGLUCUserGenderPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserGenderPropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_gender",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelPotentialValuesKey : @[GLUCLoc(@"helloactivity_gender_list_1"), GLUCLoc(@"helloactivity_gender_list_2"), GLUCLoc(@"helloactivity_gender_list_3")],
                            kGLUCModelDefaultIndexKey : @0
                    },
                    kGLUCUserIllnessTypePropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserIllnessTypePropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_spinner_diabetes_type",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelPotentialValuesKey : @[GLUCLoc(@"helloactivity_spinner_diabetes_type_1"), GLUCLoc(@"helloactivity_spinner_diabetes_type_2"),
                                GLUCLoc(@"helloactivity_spinner_diabetes_type_3"),
                                GLUCLoc(@"helloactivity_spinner_diabetes_type_4")],
                            kGLUCModelDefaultIndexKey : @1,
                    },
                    kGLUCUserPreferredBloodGlucoseUnitsPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserPreferredBloodGlucoseUnitsPropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_spinner_preferred_unit",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelPotentialValuesKey : @[GLUCLoc(@"helloactivity_spinner_preferred_unit_1"), GLUCLoc(@"helloactivity_spinner_preferred_unit_2")],
                            kGLUCModelDefaultIndexKey : @0,
                    },
                    kGLUCUserPreferredBodyWeightUnitsPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserPreferredBodyWeightUnitsPropertyKey,
                            kGLUCModelAttributeTitleKey : @"Preferred Weight Unit", // TODO: localise properly
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelPotentialValuesKey : @[GLUCLoc(@"Kilograms"), GLUCLoc(@"Pounds")],
                            kGLUCModelDefaultIndexKey : @0,
                    },
                    kGLUCUserPreferredA1CUnitsPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserPreferredA1CUnitsPropertyKey,
                            kGLUCModelAttributeTitleKey : @"Preferred HbA1c Unit",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelPotentialValuesKey : @[GLUCLoc(@"Percentage"), GLUCLoc(@"mmol/mol")],
                            kGLUCModelDefaultIndexKey : @0,
                    },

                    kGLUCUserRangeTypePropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserRangeTypePropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_spinner_preferred_range",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelPotentialValuesKey : [[GLUCRange allRanges] valueForKey:@"rangeName"],
                            kGLUCModelDefaultIndexKey : @0,
                    },
                    kGLUCUserRangeMinPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserRangeMinPropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_preferred_range_min",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                    },
                    kGLUCUserRangeMaxPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserRangeMaxPropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_preferred_range_max",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                    },
                    kGLUCUserAllowResearchUsePropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserAllowResearchUsePropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_share_data",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelDefaultValueKey : @YES
                    },
            }
    };
}

- (void)setupDefaultData {
}

- (instancetype)init {
    if ((self = [super init]) != nil) {
        self.countryPreference = [self defaultStringValueForKey:kGLUCUserCountryPreferenceKey];
        self.age = nil;
        self.gender = [self defaultLookupIndexValueForKey:kGLUCUserGenderPropertyKey];
        self.illnessType = [self defaultLookupIndexValueForKey:kGLUCUserIllnessTypePropertyKey];
        self.preferredBloodGlucoseUnitOfMeasure = [self defaultLookupIndexValueForKey:kGLUCUserPreferredBloodGlucoseUnitsPropertyKey];
        self.preferredBodyWeightUnitOfMeasure = [self defaultLookupIndexValueForKey:kGLUCUserPreferredBodyWeightUnitsPropertyKey];
        self.preferredA1CUnitOfMeasure = [self defaultLookupIndexValueForKey:kGLUCUserPreferredA1CUnitsPropertyKey];
        self.allowResearchUse = [self defaultValueForKey:kGLUCUserAllowResearchUsePropertyKey];
        self.rangeType = @0;
        self.rangeMin = @70;
        self.rangeMax = @180;

        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.positiveFormat = @"0.00";
    }
    return self;
}

- (NSArray *)requiredStartProperties {
    NSArray *retVal = nil;
    NSDictionary *mySchema = [[(id)self class] schema];
    if (mySchema) {
        retVal = mySchema[kGLUCModelRequiredStartPropertiesKey];
    }
    return retVal;
}

+ (NSArray *)ignoredProperties {
    return @[@"countryPreference", @"age", @"gender", @"illnessType",
            @"preferredBloodGlucoseUnitOfMeasure", @"preferredBodyWeightUnitOfMeasure",
            @"preferredA1CUnitOfMeasure", @"rangeType", @"rangeMin", @"rangeMax",
            @"allowResearchUse",@"numberFormatter"];
}

- (id)transformedValueForKey:(NSString *) key {
    id retVal = [super transformedValueForKey:key];
    
    if (key && key.length &&
        ([key isEqualToString:kGLUCUserRangeMaxPropertyKey] ||
         [key isEqualToString:kGLUCUserRangeMinPropertyKey]))
    {
        if ([[retVal class] isSubclassOfClass:[NSNumber class]]) {
            if ([self needsBloodGlucoseReadingUnitConversion]) {
                NSNumber *convertedVal = [GLUCBloodGlucoseReading convertValue:retVal fromUnits:kGLUCUnitOfMeasure_mgDl toUnits:kGLUCUnitOfMeasure_mmolL];
                retVal = convertedVal;
            }
        }
    }
    return retVal;
}

- (NSString *)displayValueForKey:(NSString *)key {
    NSString *retVal = @"";
    if (key && key.length) {
        if ([key isEqualToString:kGLUCUserRangeMaxPropertyKey] ||
            [key isEqualToString:kGLUCUserRangeMinPropertyKey]) {
            id val = [self transformedValueForKey:key];
            if ([[val class] isSubclassOfClass:[NSNumber class]]) {
                retVal = [self.numberFormatter stringFromNumber:val];
            }
        } else {
            retVal = [super displayValueForKey:key];
        }
    }
    return retVal;
}

- (NSArray *)settingsProperties {
    NSArray *retVal = nil;
    NSDictionary *mySchema = [[(id)self class] schema];
    if (mySchema) {
        retVal = mySchema[kGLUCModelSettingsPropertiesKey];
    }
    return retVal;
}

- (NSArray *)indirectLookupKeys {
    return @[kGLUCUserCountryPreferenceKey];
}

- (BOOL) validateAge:(id *)ioValue error:(NSError **)outError {
    BOOL retVal = YES;

    if (*ioValue) {
        NSNumber *ageVal = (NSNumber *)*ioValue;
        if (ageVal) {
            NSNumber *minAllowed = [self minimumOfRangeForKey:kGLUCUserAgePropertyKey];
            NSNumber *maxAllowed = [self maximumOfRangeForKey:kGLUCUserAgePropertyKey];

            retVal = ((ageVal.intValue <= maxAllowed.intValue) && (ageVal.intValue >= minAllowed.intValue));
        }
    }

    return retVal;
}

- (BOOL)needsBloodGlucoseReadingUnitConversion {
    return ((BOOL)[self.preferredBloodGlucoseUnitOfMeasure intValue]);
}

- (BOOL)needsHbA1CReadingUnitConversion {
    return ((BOOL)[self.preferredA1CUnitOfMeasure intValue]);
}

- (BOOL)needsBodyWeightReadingUnitConversion {
    return ((BOOL)[self.preferredBodyWeightUnitOfMeasure intValue]);
}

- (NSNumber *)glucose:(NSNumber *)mgDlValue inUnits:(NSInteger)units {
    NSNumber *retVal = mgDlValue;
    if (units) {
        retVal = [GLUCBloodGlucoseReading glucoseToMmolL:mgDlValue];
    }
    return retVal;
}

- (NSNumber *)bloodGlucoseReadingValueInPreferredUnits:(GLUCBloodGlucoseReading *)reading {
    return [self glucose:reading.reading inUnits:[self.preferredBloodGlucoseUnitOfMeasure doubleValue]];
}

// Let the user's preferences take effect if display needs to be in different units
- (NSString *) displayValueForReading:(GLUCReading *)aReading {
    NSString *valueStr = @"";
    if (aReading) {
        NSNumber *displayVal = [aReading readingInUnits:[self unitPreferenceForReadingType:[aReading class]]];
        valueStr = [self.numberFormatter stringFromNumber:displayVal];
    }
    return valueStr;
}

- (NSString *)displayUnitsForBloodGlucoseReadings {
    return [self displayValueForKey:kGLUCUserPreferredBloodGlucoseUnitsPropertyKey];
}

- (NSString *)displayUnitsForBodyWeightReadings {
    return [self displayValueForKey:kGLUCUserPreferredBodyWeightUnitsPropertyKey];
}

- (NSString *)displayUnitsForHbA1cReadings {
    return [self displayValueForKey:kGLUCUserPreferredA1CUnitsPropertyKey];
}


- (NSString *)displayUnitsForReading:(GLUCReading *)aReading {
    NSString *retVal = @"";
    if (aReading && [aReading isKindOfClass:[GLUCBloodGlucoseReading class]]) {
        retVal = [self displayUnitsForBloodGlucoseReadings];
    }
    if (aReading && [aReading isKindOfClass:[GLUCBodyWeightReading class]]) {
        retVal = [self displayUnitsForBodyWeightReadings];
    }
    if (aReading && [aReading isKindOfClass:[GLUCHbA1cReading class]]) {
        retVal = [self displayUnitsForHbA1cReadings];
    }
    return retVal;
}

- (NSInteger) unitPreferenceForReadingType:(Class)readingType {
    NSInteger retVal = 0;
    
    // superclass comparison required since Realm changes the class dynamically
    if ([readingType superclass] == [GLUCBloodGlucoseReading class] || readingType == [GLUCBloodGlucoseReading class] ) {
        retVal = [self.preferredBloodGlucoseUnitOfMeasure integerValue];
    }
    if ([readingType superclass] == [GLUCBodyWeightReading class] || readingType == [GLUCBodyWeightReading class]) {
        retVal = [self.preferredBodyWeightUnitOfMeasure integerValue];
    }
    if ([readingType superclass] == [GLUCHbA1cReading class] || readingType == [GLUCHbA1cReading class]) {
        retVal = [self.preferredA1CUnitOfMeasure integerValue];
    }
    return retVal;
}

// TODO: move this into the readings to handle appropriate conversion to default units
- (void)setNewValue:(NSNumber *)value inReading:(GLUCReading *)reading {
    NSNumber *newValue = [[reading class] convertValue:value fromUnits:[self unitPreferenceForReadingType:[reading class]] toUnits:0];
    if (reading && newValue) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        reading.reading = newValue;
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
}

// all supported reading types
- (NSArray *) readingTypes {
    return @[GLUCBloodGlucoseReading.class, GLUCHbA1cReading.class, GLUCCholesterolReading.class, GLUCBloodPressureReading.class, GLUCKetonesReading.class, GLUCBodyWeightReading.class,
             GLUCSleep.class, GLUCTreatment.class, GLUCMedication.class, GLUCExercise.class, GLUCFood.class];
}


- (NSString *) hb1acAverageValue {
    NSInteger h1bacUnits = [[self preferredA1CUnitOfMeasure] integerValue];
    NSString *suffix = (h1bacUnits == 0) ? @"%" : @" mmol/mol";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *retVal = @"";

    NSArray *averages = [GLUCBloodGlucoseReading averageMonthlyReadings];

    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];

    if (averages && [averages count]) {
        NSDictionary *lastMonth = [averages lastObject];
        if (lastMonth) {
            NSNumber *avg = [lastMonth valueForKey:@"average"];
            if (avg) {
                NSNumber *h1bacValue = nil;
                if (h1bacUnits == 0) {
                    h1bacValue = [GLUCBloodGlucoseReading glucoseToA1CAsPercentage:avg];
                } else {
                    h1bacValue = [GLUCBloodGlucoseReading glucoseToA1CAsMmolMol:avg];
                }


                retVal = [formatter stringFromNumber:h1bacValue];
            }
        }
    }

    if (retVal.length == 0) {
        retVal = GLUCLoc(@"Not enough data to calculate HbA1c");
        suffix = @"";
    }

    return [retVal stringByAppendingString:suffix];
}
@end
