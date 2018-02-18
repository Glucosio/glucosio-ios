//
//  GLUCDataServiceReading.h
//  glucosio
//
//  Created by Chris Walters on 2/13/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCModel.h"
#import "GLUCReading.h"
#import "GLUCDataService.h"

@interface GLUCDataServiceReading : GLUCModel
@property (nonatomic, strong) NSString *glucReadingID; // id of imported reading
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSNumber<RLMInt> *batchID;
@end
