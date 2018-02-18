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

+ (NSArray *) readingTypes {
    return @[
             GLUCLoc(@"Snack Bolus"), // "Snack Bolus"
             GLUCLoc(@"Meal Bolus"), // "Meal Bolus"
             GLUCLoc(@"Correction Bolus"), // "Correction Bolus"
             GLUCLoc(@"Pump Site Change"), // "Pump Site Change"
             GLUCLoc(@"Before Dinner"), // "Before dinner"
             GLUCLoc(@"After Dinner"), // "After dinner"
             GLUCLoc(@"Snack"), // "Snack"
             GLUCLoc(@"Bedtime"), // "Bedtime"
             GLUCLoc(@"Night"), // "Night"
             GLUCLoc(@"Fasting glucose"), // "Fasting glucose"
             GLUCLoc(@"Recheck"), // "Recheck"
             GLUCLoc(@"Other"), // "Other"
             ];
}

@end
