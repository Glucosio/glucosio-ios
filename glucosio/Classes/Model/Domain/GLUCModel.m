#import <Realm/Realm.h>
#import "GLUCUser.h"
#import "GLUCModel.h"

@interface GLUCModel ()
@end

@implementation GLUCModel


+ (NSString *)title {
    return nil;
}

+ (NSString *)primaryKey {
    return kGLUCModelIdKey;
}

+ (NSArray *)ignoredProperties {
    return @[@"schema", @"ownerId"];
}


- (instancetype) init {
    if ((self = [super init]) != nil) {
        self.glucID = [[NSUUID UUID] UUIDString];
        self.creationDate = [NSDate date];
        self.modificationDate = self.creationDate;
    }
    return self;
}


- (NSArray *)potentialValuesForKey:(NSString *)key {
    NSArray *retVal = nil;

    if (key && key.length && self.schema) {
        NSDictionary *attributes = [[self.schema valueForKey:kGLUCModelSchemaPropertiesKey] valueForKey:key];
        if (attributes) {
            retVal = [attributes valueForKey:kGLUCModelPotentialValuesKey];
        }
    }
    return retVal;
}

- (NSArray *)potentialDisplayValuesForKey:(NSString *)key {
    NSArray *retVal = nil;

    if (key && key.length && self.schema) {
        NSDictionary *attributes = [[self.schema valueForKey:kGLUCModelSchemaPropertiesKey] valueForKey:key];
        if (attributes) {
            retVal = [attributes valueForKey:kGLUCModelPotentialValuesKey];
            if ([[self indirectLookupKeys] containsObject:key]) {
                NSMutableArray *countryNames = [NSMutableArray array];
                for (NSString *code in retVal) {
                    [countryNames addObject:[[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code]];
                }
                retVal = [NSArray arrayWithArray:countryNames];
            }
        }
    }
    return retVal;
}

- (NSString *)titleForKey:(NSString *)key {
    NSString *retVal = nil;

    if (key && key.length && self.schema) {
        NSString *nonLocalizedTitle = [[[self.schema valueForKey:kGLUCModelSchemaPropertiesKey] valueForKey:key] valueForKey:@"title"];
        if (nonLocalizedTitle) {
            retVal = GLUCLoc(nonLocalizedTitle);
        }
    }

    return retVal;
}

- (BOOL)propertyIsLookup:(NSString *)key {
    BOOL retVal = NO;

    if (key && key.length && self.schema) {
        NSDictionary *attributes = [[self.schema valueForKey:kGLUCModelSchemaPropertiesKey] valueForKey:key];
        if (attributes) {
            NSArray *potentialValues = [self potentialValuesForKey:key];
            if (potentialValues && potentialValues.count) {
                retVal = YES;
            }
        }
    }
    return retVal;
}

- (BOOL)propertyIsIndirectLookup:(NSString *)key {
    BOOL retVal = NO;
    
    if ([self propertyIsLookup:key]) {
        NSArray *indirectLookups = [self indirectLookupKeys];
        if (indirectLookups && indirectLookups.count) {
            NSUInteger index = [indirectLookups indexOfObject:key];
            if (index != NSNotFound) {
                retVal = YES;
            }
        }
    }
    return retVal;
}

- (id)transformedValueForKey:(NSString *) key {
    id retVal = nil;

    if (key && key.length && self.schema) {
        retVal = [self valueForKey:key];
        if (retVal) {
            if ([[self indirectLookupKeys] containsObject:key]) {
                retVal = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:retVal];
            }
        }
    }
    return retVal;
}

- (NSNumber *)lookupIndexFromDisplayValue:(NSString *)displayValue forKey:(NSString *)key {
    NSNumber *retVal = nil;
    if (key && key.length && displayValue && displayValue.length && self.schema) {
        NSArray *displayValues = [self potentialDisplayValuesForKey:key];
        if (displayValues && displayValues.count) {
            NSUInteger index = [displayValues indexOfObject:displayValue];
            if (index != NSNotFound) {
                retVal = @(index);
            }
        }
    }
    return retVal;
}

- (NSNumber *)lookupIndexForKey:(NSString *)key {
    NSNumber *retVal = @0;

    if (key && key.length && self.schema) {
        id val = [self valueForKey:key];
        if ([[self indirectLookupKeys] containsObject:key]) {
            NSArray *potentialValues = [self potentialValuesForKey:key];
            if (val && potentialValues && potentialValues.count) {
                NSUInteger index = [potentialValues indexOfObject:val];
                retVal = @(index);
            }
        } else {
            if (val)
                retVal = val;
        }
    }

    return retVal;
}

- (NSNumber *)defaultLookupIndexValueForKey:(NSString *)key {
    NSNumber *retVal = @0;

    if (key && key.length && self.schema) {
        NSDictionary *attributes = [[self.schema valueForKey:kGLUCModelSchemaPropertiesKey] valueForKey:key];
        if (attributes) {
            retVal = [attributes valueForKey:kGLUCModelDefaultValueKey];
            if (!retVal) {
                NSArray *potentialValues = [self potentialValuesForKey:key];
                if (potentialValues && potentialValues.count) {
                    NSUInteger defaultIndex = [[attributes valueForKey:kGLUCModelDefaultIndexKey] unsignedIntegerValue];
                    if (defaultIndex < potentialValues.count) {
                        retVal = @(defaultIndex);
                    }
                }
            }
        }

    }
    return retVal;

}

- (id)defaultValueForKey:(NSString *)key {
    id retVal = @"";

    if (key && key.length && self.schema) {
        NSDictionary *attributes = [[self.schema valueForKey:kGLUCModelSchemaPropertiesKey] valueForKey:key];
        if (attributes) {
            retVal = [attributes valueForKey:kGLUCModelDefaultValueKey];
            if (!retVal) {
                NSArray *potentialValues = [self potentialValuesForKey:key];
                if (potentialValues && potentialValues.count) {
                    NSUInteger defaultIndex = [[attributes valueForKey:kGLUCModelDefaultIndexKey] unsignedIntegerValue];
                    if (defaultIndex < potentialValues.count) {
                        retVal = potentialValues[defaultIndex];
                    }
                }
            }
        }

    }

    if (!retVal)
        retVal = @"";

    return retVal;
}

- (NSString *)defaultStringValueForKey:(NSString *)key {
    NSString *retVal = [NSString stringWithFormat:@"%@", [self defaultValueForKey:key]];
    return retVal;
}

- (id)lookupAtIndex:(NSNumber *)anIndex forKey:(NSString *)key {
    id retVal = @"";

    if (anIndex && key && key.length && self.schema) {
        NSDictionary *attributes = [[self.schema valueForKey:kGLUCModelSchemaPropertiesKey] valueForKey:key];
        if (attributes) {
            NSArray *potentialValues = [self potentialValuesForKey:key];
            NSUInteger index = [anIndex unsignedIntegerValue];
            if (potentialValues && potentialValues.count && index < potentialValues.count) {
                retVal = potentialValues[index];
            }
        }
    }
    return retVal;
}

- (NSString *)displayValueForKey:(NSString *)key {
    NSString *retVal = @"";
    if (key) {

        id val = [self transformedValueForKey:key];

        if (val) {
            if ([self propertyIsLookup:key] && [val isKindOfClass:[NSNumber class]]) {
                NSNumber *indexVal = (NSNumber *)val;
                retVal = [NSString stringWithFormat:@"%@", [self lookupAtIndex:indexVal forKey:key]];
            } else {
                retVal = [NSString stringWithFormat:@"%@", val];
            }
        }
    }
    return retVal;
}

- (void)setValueFromLookupAtIndex:(NSNumber *)index forKey:(NSString *)key {
    if (key && key.length && self.schema) {
        [[self realm] beginWriteTransaction];
        if ([[self indirectLookupKeys] containsObject:key]) {
            id val = [self lookupAtIndex:index forKey:key];
            [self setValue:val forKey:key];
        } else {
            [self setValue:index forKey:key];
        }
        [[self realm] commitWriteTransaction];
    }
}

- (NSArray *)indirectLookupKeys {
    return @[];
}

- (NSNumber *) rangeElement:(NSString *)elementName forKey:(NSString *)key {
    NSNumber *retVal = nil;

    if (key && key.length && self.schema) {
        NSDictionary *attributes = [[self.schema valueForKey:kGLUCModelSchemaPropertiesKey] valueForKey:key];
        if (attributes) {
            NSDictionary *rangeValues = [attributes valueForKey:kGLUCModelAttributeValidRangeKey];
            if (rangeValues) {
                retVal = [rangeValues valueForKey:elementName];
            }
        }

    }

    return retVal;
    
}

- (NSNumber *) minimumOfRangeForKey:(NSString *)key {
    return [self rangeElement:@"min" forKey:key];
}

- (NSNumber *) maximumOfRangeForKey:(NSString *)key {
    return [self rangeElement:@"max" forKey:key];
}


@end
