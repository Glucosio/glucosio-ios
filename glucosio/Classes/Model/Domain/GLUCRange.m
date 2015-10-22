#import "GLUCRange.h"

@implementation GLUCRange

+ (NSArray *) allRanges {

    // @[GLUCLoc(@"ADA"), GLUCLoc(@"AACE"), GLUCLoc(@"UK NICE"), GLUCLoc(@"Custom"
    NSArray *retVal = @[
            @{
                    @"rangeName" : @"ADA",
                    @"min" : @70,
                    @"max" : @180
            },
            @{
                    @"rangeName" : @"AACE",
                    @"min" : @110,
                    @"max" : @140
            },
            @{
                    @"rangeName" : @"UK NICE",
                    @"min" : @72,
                    @"max" : @153
            },
            @{
                    @"rangeName" : @"Custom",
                    @"min" : @70,
                    @"max" : @180
            }
    ];

    return retVal;
}

@end
