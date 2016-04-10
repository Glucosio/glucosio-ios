//
// Created by Chris Walters on 4/10/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUCModel.h"


@interface GLUCReading : GLUCModel
@property (nonatomic, readwrite, strong) NSNumber *value;
@property (nonatomic, readwrite, strong) NSString *notes;
@end