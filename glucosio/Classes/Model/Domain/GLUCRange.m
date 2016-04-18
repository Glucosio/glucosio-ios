#import <Realm/Realm.h>
#import "GLUCRange.h"

@implementation GLUCRange

+ (NSArray *) allRanges {

    // @[GLUCLoc(@"ADA"), GLUCLoc(@"AACE"), GLUCLoc(@"UK NICE"), GLUCLoc(@"Custom"
    NSArray *retVal = @[
            @{
                    @"rangeName" : GLUCLoc(@"helloactivity_spinner_preferred_range_1"),
                    @"min" : @70,
                    @"max" : @180
            },
            @{
                    @"rangeName" : GLUCLoc(@"helloactivity_spinner_preferred_range_2"),
                    @"min" : @110,
                    @"max" : @140
            },
            @{
                    @"rangeName" : GLUCLoc(@"helloactivity_spinner_preferred_range_3"),
                    @"min" : @72,
                    @"max" : @153
            },
            @{
                    @"rangeName" : GLUCLoc(@"helloactivity_spinner_preferred_range_4"),
                    @"min" : @70,
                    @"max" : @180
            }
    ];

    return retVal;
}

@end
