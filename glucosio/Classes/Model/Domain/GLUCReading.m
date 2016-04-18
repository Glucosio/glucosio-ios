//
// Created by Chris Walters on 4/10/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Realm/Realm.h>
#import "GLUCReading.h"


@implementation GLUCReading {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.reading = @0;
        self.notes = @"";
    }

    return self;
}


@end