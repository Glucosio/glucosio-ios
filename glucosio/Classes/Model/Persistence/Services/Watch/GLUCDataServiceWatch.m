//
//  GLUCDataServiceWatch.m
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import <WatchConnectivity/WatchConnectivity.h>

#import "GLUCDataServiceWatch.h"
#import "TimelineUtil.h"
#import "glucosio-Swift.h"

@implementation GLUCDataServiceWatch

- (void) updateWatch {
    NSDictionary * context = [[TimelineUtil load24hTimeline: self.database.currentUser] toDictionary];
    if (context) {
        [WCSession.defaultSession updateApplicationContext:context error:nil];
    }
}

- (BOOL)allowsImportForReadingType:(Class)readingType {
    return NO;
}

- (BOOL)allowsExportForReadingType:(Class)readingType {
    BOOL allowsExportForType = NO;
    
    if ([readingType isSubclassOfClass:[GLUCBloodGlucoseReading class]]) {
        allowsExportForType = YES;
    }
    return allowsExportForType;
}

- (BOOL)exportReadings:(RLMResults<GLUCReading *> *)readings ofType:(Class)readingType forUser:(GLUCUser *)user {
    if ([self.serviceEnabled boolValue]) {
        [self updateWatch];
    } else {
        NSLog(@"Service: %@ - disabled", self.serviceName);
    }
    return YES;
}

- (BOOL) importReadingsOfType:(Class)readingType forUser:(GLUCUser *)user {
    return NO;
}

@end
