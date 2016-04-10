#import <Foundation/Foundation.h>
#import "GLUCModel.h"
#import "GLUCReading.h"

static NSString *const kGLUCReadingReadingTypeIdPropertyKey = @"readingTypeId";
static NSString *const kGLUCReadingModelCustomTypeNamePropertyKey = @"readingCustomTypeName";

@interface GLUCBloodGlucoseReading : GLUCReading

@property (nonatomic, readwrite, strong) NSNumber *readingTypeId;
@property (nonatomic, readwrite, strong) NSString *readingCustomTypeName;

+ (NSArray *) readingTypes;
- (NSString *) readingType;

- (NSString *) readingTypeForId:(NSInteger) readingTypeId;
- (NSInteger) readingTypeIdForHourOfDay:(NSInteger)hour;

@end
