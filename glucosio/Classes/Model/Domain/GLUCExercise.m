//
//  GLUCExercise.m
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCExercise.h"

@implementation GLUCExercise

+ (NSString *)title {
    return GLUCLoc(@"Exercise");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_Exercise";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_weight];
}

@end
