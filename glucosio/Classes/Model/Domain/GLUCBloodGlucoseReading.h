#import <Foundation/Foundation.h>
#import "GLUCModel.h"
#import "GLUCReading.h"

static NSString *const kGLUCReadingReadingTypeIdPropertyKey = @"readingTypeId";

@interface GLUCBloodGlucoseReading : GLUCReading

@property (nonatomic, readwrite, strong) NSNumber<RLMInt> *readingTypeId;

+ (NSArray *) readingTypes;
- (NSString *) readingType;

//HKMetadataKeyBloodGlucoseMealTime values
- (NSString *) healthKitMealTime;

- (NSString *) readingTypeForId:(NSInteger) readingTypeId;
- (NSInteger) readingTypeIdForHourOfDay:(NSInteger)hour;

+ (NSArray *) averageMonthlyReadings;
+ (RLMResults<GLUCBloodGlucoseReading *> *) last24hReadings;

+ (NSNumber *) glucoseToMgDl:(NSNumber *) mmolL_glucose;
+ (NSNumber *) glucoseToMmolL:(NSNumber *) mgDl_glucose;

+ (NSNumber *) glucoseToA1CAsPercentage:(NSNumber *)mgDl_glucose;
+ (NSNumber *) glucoseToA1CAsMmolMol:(NSNumber *)mgDl_glucose;
+ (NSNumber *) glucoseToA1CInUnits:(NSInteger)units forValue:(NSNumber *)value;

@end
