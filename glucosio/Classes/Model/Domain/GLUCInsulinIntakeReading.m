//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import "GLUCInsulinIntakeReading.h"


@implementation GLUCInsulinIntakeReading {

}

+ (NSString *)title {
    return GLUCLoc(@"Insulin Intake");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_InsulinIntake";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_insulin];
}
@end
