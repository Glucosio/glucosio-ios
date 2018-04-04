//
//  GLUCDataService.m
//  glucosio
//
//  Created by Chris Walters on 2/11/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCDataService.h"

@implementation GLUCDataService

+ (NSArray *) ignoredProperties {
    return @[@"database"];
}

+ (NSString *) primaryKey {
    return @"serviceName";
}

- (instancetype)init {
    if ((self = [super init]) != nil) {
        self.serviceName = @"Untitled";
        self.serviceEnabled = @(0);
        self.mgdLLowAlarmThreshold = [NSNumber numberWithInt:80];
        self.mgdLHighAlarmThreshold = [NSNumber numberWithInt:180];
    }
    return self;
}

- (BOOL)allowsImportForReadingType:(Class)readingType {
    return NO;
}

- (BOOL)allowsExportForReadingType:(Class)readingType {
    return NO;
}

- (BOOL)exportReadings:(RLMResults<GLUCReading *> *)readings ofType:(Class)readingType forUser:(GLUCUser *)user {
    return NO;
}

- (BOOL) importReadingsOfType:(Class)readingType forUser:(GLUCUser *)user {
    return NO;
}

- (BOOL) configure {
    return NO;
}

@end
