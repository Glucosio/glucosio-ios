#import <Foundation/Foundation.h>
#import "GLUCModel.h"

static NSString *const kGLUCReadingReadingTypeIdPropertyKey = @"readingTypeId";
static NSString *const kGLUCReadingModelValuePropertyKey = @"value";
static NSString *const kGLUCReadingNotesPropertyKey = @"notes";
static NSString *const kGLUCReadingModelCustomTypeNamePropertyKey = @"readingCustomTypeName";

@interface GLUCReading : GLUCModel

@property (nonatomic, readwrite, strong) NSNumber *value;
@property (nonatomic, readwrite, strong) NSNumber *readingTypeId;
@property (nonatomic, readwrite, strong) NSString *notes;
@property (nonatomic, readwrite, strong) NSNumber *ownerId;
@property (nonatomic, readwrite, strong) NSString *readingCustomTypeName;

+ (NSArray *) readingTypes;
- (NSString *) readingType;

- (NSString *) readingTypeForId:(NSInteger) readingTypeId;
- (NSInteger) readingTypeIdForHourOfDay:(NSInteger)hour;

@end
