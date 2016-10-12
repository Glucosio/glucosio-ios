//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import "GLUCHbA1cReading.h"


@implementation GLUCHbA1cReading {

}

+ (NSString *)title {
    return GLUCLoc(@"HbA1c Reading");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_a1c";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_HbA1c];
}

// percentage to mmol/mol
+ (NSNumber *) a1cNgspToIfcc:(NSNumber *)ngspValue {
    return @((ngspValue.doubleValue - 2.152)/0.09148);
}

// mmol/mol to percentage
+ (NSNumber *) a1cIfccToNgsp:(NSNumber *)ifccValue {
    return @((0.09148 * ifccValue.doubleValue) + 2.152);
}

// units = 0 is always the default units for the reading

+ (NSNumber *) convertValue:(NSNumber *)aValue fromUnits:(NSInteger)fromUnits toUnits:(NSInteger)toUnits {
    NSNumber *retVal = aValue;
    if (fromUnits != toUnits) {
        if (fromUnits == 0 && toUnits == 1) {
            retVal = [self a1cNgspToIfcc:aValue];
        }
        if (fromUnits == 1 && toUnits == 0) {
            retVal = [self a1cIfccToNgsp:aValue];
        }
    }
    return retVal;
    
}

- (NSNumber *) readingInUnits:(NSInteger)units {
    return [[self class] convertValue:self.reading fromUnits:0 toUnits:units];
}
@end