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


@end