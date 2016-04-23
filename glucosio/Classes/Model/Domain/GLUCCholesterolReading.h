//
// Created by Chris Walters on 4/16/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUCReading.h"

static NSString *const kGLUCReadingLDLReadingPropertyKey = @"ldlReading";
static NSString *const kGLUCReadingHDLReadingPropertyKey = @"hdlReading";

@interface GLUCCholesterolReading : GLUCReading

@property (nonatomic, readwrite, strong) NSNumber<RLMFloat> *ldlReading;
@property (nonatomic, readwrite, strong) NSNumber<RLMFloat> *hdlReading;

@end