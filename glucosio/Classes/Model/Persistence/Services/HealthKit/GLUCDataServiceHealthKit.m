//
//  GLUCHealthKitService.m
//  glucosio
//
//  Created by Chris Walters on 2/14/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import "GLUCDataServiceHealthKit.h"

@implementation GLUCDataServiceHealthKit

+ (NSArray *) ignoredProperties {
    return @[@"healthStore"];
}

- (BOOL)canAccessQuantityTypesForImport:(NSSet *)importTypes exportTypes:(NSSet *)exportTypes {
    __block BOOL allowAccess = NO;
    if ([HKHealthStore isHealthDataAvailable]) {
        if (!self.healthStore) {
            self.healthStore = [[HKHealthStore alloc] init];
        }
        for (HKQuantityType *quantityType in importTypes) {
            HKAuthorizationStatus authStatus = [self.healthStore authorizationStatusForType:quantityType];
            
            if (authStatus == HKAuthorizationStatusNotDetermined) {
                [self.healthStore requestAuthorizationToShareTypes:exportTypes readTypes:importTypes completion:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        allowAccess = YES;
                    }
                }];
            } else {
                if (authStatus == HKAuthorizationStatusSharingAuthorized) {
                    allowAccess = YES;
                }
            }
        }
    }
    return allowAccess;
}

- (NSSet *) importTypes {
    return [NSSet setWithObject:[GLUCBloodGlucoseReading healthKitQuantityType]];
}

- (NSSet *) exportTypes {
    return [self importTypes];
}

- (BOOL) configure {
    BOOL accessOk = [self canAccessQuantityTypesForImport:[self importTypes] exportTypes:[self exportTypes]];
    return accessOk;
}

- (BOOL)allowsImportForReadingType:(Class)readingType {
    BOOL allowImport = NO;
    
    if ([readingType isSubclassOfClass:[GLUCBloodGlucoseReading class]]) {
        allowImport = [self canAccessQuantityTypesForImport:[self importTypes] exportTypes:[self exportTypes]];
    }
    return allowImport;
}

- (BOOL)allowsExportForReadingType:(Class)readingType {
    return [self allowsImportForReadingType:readingType];
}

- (BOOL)exportReadings:(RLMResults<GLUCReading *> *)readings ofType:(Class)readingType forUser:(GLUCUser *)user {
    if (![self.serviceEnabled boolValue]) {
        NSLog(@"Service: %@ - disabled", self.serviceName);
        return NO;
    }
    __block BOOL result = YES;
    for (GLUCReading *reading in readings) {
        GLUCBloodGlucoseReading *bgr = (GLUCBloodGlucoseReading *)reading;
        HKQuantity *quantity = [HKQuantity quantityWithUnit:[HKUnit unitFromString:@"mg/dL"] doubleValue:[bgr.reading doubleValue]];
        NSDictionary *metadata = @{@"HKMetadataKeyBloodGlucoseMealTime" : [bgr healthKitMealTime] };
        HKQuantitySample *readingSample = [HKQuantitySample quantitySampleWithType:[GLUCBloodGlucoseReading healthKitQuantityType]
                                                                          quantity:quantity
                                                                         startDate:reading.creationDate
                                                                           endDate:reading.creationDate
                                                                          metadata:metadata];
        
        if (!self.healthStore) {
            self.healthStore = [[HKHealthStore alloc] init];
        }

        [self.healthStore saveObject:readingSample withCompletion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                result = YES;
            }
        }];
    }
    return result;
}


- (BOOL) importReadingsOfType:(Class)readingType forUser:(GLUCUser *)user {
    __block BOOL dataLoaded = NO;
    return dataLoaded;
}

@end
