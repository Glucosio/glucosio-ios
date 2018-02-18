//
//  GLUCFood.m
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCFood.h"

@implementation GLUCFood

+ (NSString *)title {
    return GLUCLoc(@"Food/Carbs");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_Food";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_weight];
}

@end
