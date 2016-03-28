#import "GLUCUser.h"
#import "GLUCRange.h"
#import "GLUCBloodGlucoseReading.h"

@interface GLUCUser ()
@end

@implementation GLUCUser

- (void)setupDefaultData {
    self.schema = @{
            kGLUCModelSettingsPropertiesKey : @[kGLUCUserCountryPreferenceKey, kGLUCUserAgePropertyKey, 
                    kGLUCUserGenderPropertyKey, kGLUCUserIllnessTypePropertyKey, kGLUCUserPreferredUnitsPropertyKey,
                    kGLUCUserRangeTypePropertyKey, kGLUCUserRangeMinPropertyKey, kGLUCUserRangeMaxPropertyKey, kGLUCUserAllowResearchUsePropertyKey],

            kGLUCModelRequiredStartPropertiesKey : @[kGLUCUserCountryPreferenceKey, kGLUCUserAgePropertyKey,
                    kGLUCUserGenderPropertyKey, kGLUCUserIllnessTypePropertyKey, kGLUCUserPreferredUnitsPropertyKey,
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
                            kGLUCModelPotentialValuesKey : @[GLUCLoc(@"helloactivity_spinner_diabetes_type_1"), GLUCLoc(@"helloactivity_spinner_diabetes_type_2")],
                            kGLUCModelDefaultIndexKey : @1,
                    },
                    kGLUCUserPreferredUnitsPropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCUserPreferredUnitsPropertyKey,
                            kGLUCModelAttributeTitleKey : @"helloactivity_spinner_preferred_unit",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                            kGLUCModelPotentialValuesKey : @[GLUCLoc(@"helloactivity_spinner_preferred_unit_1"), GLUCLoc(@"helloactivity_spinner_preferred_unit_2")],
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

- (instancetype)init {
    if ((self = [super init]) != nil) {
        [self setupDefaultData];


        self.countryPreference = [self defaultStringValueForKey:kGLUCUserCountryPreferenceKey];
        self.age = nil;
        self.gender = [self defaultLookupIndexValueForKey:kGLUCUserGenderPropertyKey];
        self.illnessType = [self defaultLookupIndexValueForKey:kGLUCUserIllnessTypePropertyKey];
        self.preferredUnifOfMeasure = [self defaultLookupIndexValueForKey:kGLUCUserPreferredUnitsPropertyKey];
        self.allowResearchUse = [self defaultValueForKey:kGLUCUserAllowResearchUsePropertyKey];
        self.rangeType = @0;
        self.rangeMin = @70;
        self.rangeMax = @180;

    }
    return self;
}

- (NSArray *)requiredStartProperties {
    NSArray *retVal = nil;
    if (self.schema) {
        retVal = self.schema[kGLUCModelRequiredStartPropertiesKey];
    }
    return retVal;
}

- (NSArray *)settingsProperties {
    NSArray *retVal = nil;
    if (self.schema) {
        retVal = self.schema[kGLUCModelSettingsPropertiesKey];
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

- (BOOL)needsUnitConversion {
    return ((BOOL)[self.preferredUnifOfMeasure intValue]);
}

- (NSNumber *)readingValueInPreferredUnits:(GLUCBloodGlucoseReading *)reading {
    if ([self needsUnitConversion]) {
        return @([reading.value intValue] / 18.0f);
    }
    return reading.value;
}

- (void) setNewValue:(NSNumber *)value inReading:(GLUCBloodGlucoseReading *)reading {
    NSNumber *newValue = value;
    if ([self needsUnitConversion]) {
        newValue = [NSNumber numberWithInteger:([value floatValue] * 18.0f)];
    }
    if (reading && newValue) {
        reading.value = newValue;
    }
}

@end
