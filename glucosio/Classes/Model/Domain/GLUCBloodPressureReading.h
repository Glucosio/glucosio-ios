//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUCReading.h"

// reading is min
static NSString *const kGLUCReadingMaxBloodPressureReadingPropertyKey = @"maxReading";

@interface GLUCBloodPressureReading : GLUCReading
@property (nonatomic, readwrite, strong) NSNumber<RLMFloat> *maxReading;
@end