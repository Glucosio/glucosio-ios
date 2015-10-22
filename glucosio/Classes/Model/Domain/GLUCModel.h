#import <Foundation/Foundation.h>
#import "GLUCLoc.h"

static NSString *const kGLUCModelInitialSettingsCompletedKey = @"initialSettingsCompleted";

static NSString *const kGLUCModelPotentialValuesKey = @"potentialValues";
static NSString *const kGLUCModelSettingsPropertiesKey = @"settingsProperties";
static NSString *const kGLUCModelSchemaPropertiesKey = @"properties";
static NSString *const kGLUCModelRequiredStartPropertiesKey = @"requiredStartProperties";
static NSString *const kGLUCModelAttributeKey = @"key";
static NSString *const kGLUCModelAttributeTitleKey = @"title";
static NSString *const kGLUCModelAttributeTypeKey = @"type";
static NSString *const kGLUCModelDefaultValueKey = @"default";
static NSString *const kGLUCModelDefaultIndexKey = @"defaultIndex";
static NSString *const kGLUCModelAttributeValidRangeKey = @"validRange";

static NSString *const kGLUCModelIdKey = @"glucId";
static NSString *const kGLUCModelCreationDateKey = @"creationDate";
static NSString *const kGLUCModelModificationDateKey = @"modificationDate";

@interface GLUCModel : NSObject

@property (nonatomic, readwrite, strong) NSNumber *glucId;
@property (nonatomic, readwrite, strong) NSDate *creationDate;
@property (nonatomic, readwrite, strong) NSDate *modificationDate;

@property (strong, nonatomic) NSDictionary *schema;

- (instancetype) init;

- (NSArray *)potentialDisplayValuesForKey:(NSString *)key;

- (NSString *)titleForKey:(NSString *)key;

- (NSNumber *)lookupIndexForKey:(NSString *)key;
- (NSNumber *)lookupIndexFromDisplayValue:(NSString *)displayValue forKey:(NSString *)key;
- (NSNumber *)lookupIndexFromSortedDisplayValue:(NSString *)displayValue forKey:(NSString *)key;

- (id)defaultValueForKey:(NSString *)key;

- (NSString *)defaultStringValueForKey:(NSString *)key;

- (NSString *)displayValueForKey:(NSString *)key;
- (NSNumber *)defaultLookupIndexValueForKey:(NSString *)key;

- (void)setValueFromLookupAtIndex:(NSNumber *)index forKey:(NSString *)key;
- (NSArray *) indirectLookupKeys;
- (BOOL)propertyIsLookup:(NSString *)key;
- (BOOL)propertyIsIndirectLookup:(NSString *)key;

- (NSNumber *) minimumOfRangeForKey:(NSString *)key;
- (NSNumber *) maximumOfRangeForKey:(NSString *)key;

@end
