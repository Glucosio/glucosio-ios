//
//  GLUCMedicine.h
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "GLUCModel.h"

@interface GLUCMedicine : GLUCModel

@property (strong, nonatomic) NSString *medicineName;
@property (strong, nonatomic) NSString *alternativeNames;
@property (strong, nonatomic) NSNumber<RLMFloat> *prescribedDosage;
@property (strong, nonatomic) NSString *schedule; // Twice daily, before bed, etc
@property (strong, nonatomic) NSString *scheduleCoded; // reserved, TBD, idea is to provide cron like schedule as to when medication should be taken

@end

