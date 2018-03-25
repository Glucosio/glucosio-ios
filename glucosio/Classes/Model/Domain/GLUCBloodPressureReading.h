//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUCReading.h"

// changes - reading is systolic (sys), second num is diastolic (dia), for both
// units are mmHg
static NSString *const kGLUCReadingDiastolicBloodPressureReadingPropertyKey = @"diastolic";

@interface GLUCBloodPressureReading : GLUCReading
@property (nonatomic, readwrite, strong) NSNumber<RLMFloat> *diastolic;
@end
