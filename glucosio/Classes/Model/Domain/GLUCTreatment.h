//
//  GLUCTreatment.h
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLUCReading.h"
#import <Realm/Realm.h>

static NSString *const kGLUCTreatmentNamePropertyKey = @"treatmentName";

@interface GLUCTreatment : GLUCReading

@property (strong, nonatomic) NSString *treatmentName;

@end
