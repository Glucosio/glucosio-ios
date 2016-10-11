//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import "GLUCKetonesReading.h"
#import "UIColor+GLUCAdditions.h"

@implementation GLUCKetonesReading {

}

+ (NSString *)title {
    return GLUCLoc(@"Ketones");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_Ketones";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_ketonest];
}

@end