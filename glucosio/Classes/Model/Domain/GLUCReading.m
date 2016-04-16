//
// Created by Chris Walters on 4/10/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

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

- (NSDictionary *)insertParameters {
    NSDictionary *readingParameters = @{
            kGLUCReadingModelValuePropertyKey : self.reading,
            kGLUCReadingNotesPropertyKey : self.notes,
    };
    NSMutableDictionary *retVal = [NSMutableDictionary dictionaryWithDictionary:[super insertParameters]];
    [retVal addEntriesFromDictionary:readingParameters];
    return [NSDictionary dictionaryWithDictionary:retVal];
}

@end