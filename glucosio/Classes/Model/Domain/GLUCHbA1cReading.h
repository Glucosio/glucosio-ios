//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUCReading.h"


@interface GLUCHbA1cReading : GLUCReading

// percentage to mmol/mol
+ (NSNumber *) a1cNgspToIfcc:(NSNumber *)ngspValue;

// mmol/mol to percentage
+ (NSNumber *) a1cIfccToNgsp:(NSNumber *)ifccValue;

@end