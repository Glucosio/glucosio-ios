//
//  GLUCSleep.h
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLUCTreatment.h"
#import <Realm/Realm.h>

@interface GLUCSleep : GLUCTreatment

@property (nonatomic, strong) NSNumber<RLMFloat> *sleepApneaEventsPerHour;
@property (nonatomic, strong) NSNumber<RLMFloat> *cpapMaskScore;
@property (nonatomic, strong) NSNumber<RLMFloat> *cpapMaskEventCount;

@end
