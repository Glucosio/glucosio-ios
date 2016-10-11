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

@end