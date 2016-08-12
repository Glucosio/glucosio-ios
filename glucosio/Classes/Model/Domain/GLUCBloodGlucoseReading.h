#import <Foundation/Foundation.h>
#import "GLUCModel.h"
#import "GLUCReading.h"

static NSString *const kGLUCReadingReadingTypeIdPropertyKey = @"readingTypeId";

@interface GLUCBloodGlucoseReading : GLUCReading

@property (nonatomic, readwrite, strong) NSNumber<RLMInt> *readingTypeId;

+ (NSArray *) readingTypes;
- (NSString *) readingType;

- (NSString *) readingTypeForId:(NSInteger) readingTypeId;
- (NSInteger) readingTypeIdForHourOfDay:(NSInteger)hour;

+ (NSArray *) averageMonthlyReadings;

+ (NSNumber *) glucoseToA1CAsPercentage:(NSNumber *)mgDl_glucose;
+ (NSNumber *) glucoseToA1CAsMmolMol:(NSNumber *)mgDl_glucose;

@end
