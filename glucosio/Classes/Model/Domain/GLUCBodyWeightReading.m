//
// Created by Chris Walters on 4/10/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import "GLUCBodyWeightReading.h"
#import "UIColor+GLUCAdditions.h"


@implementation GLUCBodyWeightReading {

}



+ (NSString *)title {
    return GLUCLoc(@"Body Weight");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_Weight";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_weight];
}

+ (NSNumber *) kgToLb:(NSNumber *)kgValue {
    return @(kgValue.doubleValue * 2.20462f);
}

+ (NSNumber *) lbToKg:(NSNumber *)lbValue {
    return @(lbValue.doubleValue / 2.20462f);
}

// units = 0 is always the default units for the reading

+ (NSNumber *) convertValue:(NSNumber *)aValue fromUnits:(NSInteger)fromUnits toUnits:(NSInteger)toUnits {
    NSNumber *retVal = aValue;
    if (fromUnits != toUnits) {
        if (fromUnits == 0 && toUnits == 1) {
            retVal = [[self class] kgToLb:aValue];
        }
        if (fromUnits == 1 && toUnits == 0) {
            retVal = [[self class] lbToKg:aValue];
        }
    }
    return retVal;
}

- (NSNumber *) readingInUnits:(NSInteger)units {
    return [[self class] convertValue:self.reading fromUnits:0 toUnits:units];
}

@end