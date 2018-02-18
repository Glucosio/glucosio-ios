//
//  GLUCHealthKitService.h
//  glucosio
//
//  Created by Chris Walters on 2/14/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCDataService.h"
#import <HealthKit/HealthKit.h>

@interface GLUCDataServiceHealthKit : GLUCDataService

@property (nonatomic, readwrite) HKHealthStore *healthStore;

@end
