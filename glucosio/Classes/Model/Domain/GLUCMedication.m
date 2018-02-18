//
//  GLUCMedication.m
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCMedication.h"

@implementation GLUCMedication

+ (NSString *)title {
    return GLUCLoc(@"Medication");
}

+ (NSString *) menuIconName {
    return @"MenuIconAdd_Medicine";
}

+ (UIColor *) readingColor {
    return [UIColor glucosio_fab_weight];
}

@end
