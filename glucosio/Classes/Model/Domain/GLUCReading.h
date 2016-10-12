//
// Created by Chris Walters on 4/10/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUCModel.h"
#import "UIColor+GLUCAdditions.h"

@protocol RLMFloat;

static NSString *const kGLUCReadingNotesPropertyKey = @"notes";
static NSString *const kGLUCReadingModelValuePropertyKey = @"reading";

@interface GLUCReading : GLUCModel

+ (NSString *) menuIconName;
+ (UIColor *) readingColor;

// units = 0 is always the default units for the reading
- (NSNumber *) readingInUnits:(NSInteger)units;
+ (NSNumber *) convertValue:(NSNumber *)aValue fromUnits:(NSInteger)fromUnits toUnits:(NSInteger)toUnits;

@property (nonatomic, readwrite, strong) NSNumber<RLMFloat> *reading;
@property (nonatomic, readwrite, strong) NSString *notes;
@end