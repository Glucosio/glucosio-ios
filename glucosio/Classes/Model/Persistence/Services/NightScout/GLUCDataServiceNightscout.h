//
//  GLUCDataServiceNightscout.h
//  glucosio
//
//  Created by Chris Walters on 2/11/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCDataService.h"

@interface GLUCDataServiceNightscout : GLUCDataService

@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *roleToken;

@end
