//
//  GLUCDataService.h
//  glucosio
//
//  Created by Chris Walters on 2/11/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUCPersistenceController.h"
#import "GLUCReading.h"
#import <Realm/Realm.h>


@protocol GLUCDataSourceConfiguration
- (BOOL) ping;
- (BOOL) configure;
- (BOOL) enable;
- (void) disable;
@end

@protocol GLUCDataSourceImport
- (BOOL) allowsImportForReadingType:(Class)readingType;
- (BOOL) importReadingsOfType:(Class)readingType forUser:(GLUCUser *)user;
@end

@protocol GLUCDataSourceExport
- (BOOL) allowsExportForReadingType:(Class)readingType;
- (BOOL) exportReadings:(RLMResults <GLUCReading *> *)readings ofType:(Class)readingType forUser:(GLUCUser *)user;
@end

@interface GLUCDataService : GLUCModel <GLUCDataSourceImport, GLUCDataSourceExport>
@property (nonatomic, weak) id <GLUCDatabase> database;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSNumber<RLMInt> *serviceEnabled;
@property (nonatomic, strong) NSDate *alarmSnoozedAt;
@property (nonatomic, strong) NSNumber<RLMInt> *alarmSnoozeSeconds;
@property (nonatomic, strong) NSNumber<RLMInt> *alarmIfNoDataMinutes;
@property (nonatomic, strong) NSNumber<RLMInt> *mgdLHighAlarmThreshold;
@property (nonatomic, strong) NSNumber<RLMInt> *mgdLLowAlarmThreshold;
@property (nonatomic, strong) NSString *lastErrorCondition;

- (BOOL) configure;

@end
