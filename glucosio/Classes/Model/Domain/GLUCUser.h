#import <Foundation/Foundation.h>
#import "GLUCModel.h"

@class GLUCBloodGlucoseReading;


static NSString *const kGLUCUserCountryPreferenceKey = @"countryPreference";
static NSString *const kGLUCUserAgePropertyKey = @"age";
static NSString *const kGLUCUserGenderPropertyKey = @"gender";
static NSString *const kGLUCUserIllnessTypePropertyKey = @"illnessType";
static NSString *const kGLUCUserPreferredBloodGlucoseUnitsPropertyKey = @"preferredBloodGlucoseUnitOfMeasure";
static NSString *const kGLUCUserPreferredBodyWeightUnitsPropertyKey = @"preferredBodyWeightUnitOfMeasure";
static NSString *const kGLUCUserPreferredA1CUnitsPropertyKey = @"preferredA1CUnitOfMeasure";
static NSString *const kGLUCUserRangeTypePropertyKey = @"rangeType";
static NSString *const kGLUCUserRangeMinPropertyKey = @"rangeMin";
static NSString *const kGLUCUserRangeMaxPropertyKey = @"rangeMax";
static NSString *const kGLUCUserAllowResearchUsePropertyKey = @"allowResearchUse";


@interface GLUCUser : GLUCModel

@property (nonatomic, readwrite, strong) NSString *countryPreference; // ISO code (language choice)
@property (nonatomic, readwrite, strong) NSNumber *age;
@property (nonatomic, readwrite, strong) NSNumber *gender; // 0 - male, 1 - female, 2 - other
@property (nonatomic, readwrite, strong) NSNumber *illnessType; // 0 - type 1, 1 - type 2
@property (nonatomic, readwrite, strong) NSNumber *preferredBloodGlucoseUnitOfMeasure; // 0 - mg/dL, 1 - mmol/L
@property (nonatomic, readwrite, strong) NSNumber *preferredBodyWeightUnitOfMeasure; // 0 - kilograms, 1 - pounds
@property (nonatomic, readwrite, strong) NSNumber *preferredA1CUnitOfMeasure; // 0 - percentage, 1 - mmol/mol
@property (nonatomic, readwrite, strong) NSNumber *rangeType; // 0 - ADA, 1 - AACE, 2 - UK NICE, 3 - custom
@property (nonatomic, readwrite, strong) NSNumber *rangeMin;
@property (nonatomic, readwrite, strong) NSNumber *rangeMax;
@property (nonatomic, readwrite, strong) NSNumber *allowResearchUse; // allow anonymous data sharing

- (NSArray *)settingsProperties;
- (NSArray *)requiredStartProperties;

- (BOOL) validateAge:(id *)ioValue error:(NSError **)outError;

- (BOOL)needsBloodGlucoseReadingUnitConversion;
- (NSNumber *)bloodGlucoseReadingValueInPreferredUnits:(GLUCBloodGlucoseReading *)reading;
- (void)setNewValue:(NSNumber *)value inBloodGlucoseReading:(GLUCBloodGlucoseReading *)reading;

@end
