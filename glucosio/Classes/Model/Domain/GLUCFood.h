//
//  GLUCFood.h
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCTreatment.h"
#import <Realm/Realm.h>

static NSString *const kGLUCReadingCarbsReadingPropertyKey = @"reading";

@interface GLUCFood : GLUCTreatment

@property (nonatomic, strong) NSString *rlmStr;

@end
