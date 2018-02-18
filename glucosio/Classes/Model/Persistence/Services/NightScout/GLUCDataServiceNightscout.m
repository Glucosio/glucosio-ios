//
//  GLUCDataServiceNightscout.m
//  glucosio
//
//  Created by Chris Walters on 2/11/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AFNetworking/AFNetworking.h>
#import "GLUCBloodGlucoseReading.h"
#import "GLUCDataServiceReading.h"
#import "GLUCDataServiceNightscout.h"

@implementation GLUCDataServiceNightscout

/*
 * The assumption is that the user will provide at least the URI:
 *
 * base URI, e.g., https://my.nightscout.server.de
 * (optional) secret key, e.g., XXXYYYAAA for XXXYYYAAA@URI
 * (optional) role token, e.g., for role based uploads
 
 */
- (NSURL *) serviceURL {
    NSURL *retVal = nil;
    if (self.uri && self.uri.length) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithString:self.uri];

        if (urlComponents) {
            if (self.secretKey && self.secretKey.length) {
                urlComponents.user = self.secretKey;
            }
            
            retVal = [urlComponents URL];
        }
    }
    return retVal;
}

- (BOOL)allowsImportForReadingType:(Class)readingType {
    BOOL allowImport = NO;
    if ([readingType isSubclassOfClass:[GLUCBloodGlucoseReading class]]) {
        allowImport = YES;
    }
    return allowImport;
}

- (BOOL)allowsExportForReadingType:(Class)readingType {
    BOOL allowExport = NO;
    if ([readingType isSubclassOfClass:[GLUCBloodGlucoseReading class]]) {
        allowExport = YES;
    }
    return allowExport;
}

- (void) triggerErrorForReading:(GLUCBloodGlucoseReading *)reading {
    
}
- (void) triggerAlarmForReading:(GLUCBloodGlucoseReading *)reading {
    NSLog(@"Posting notification for reading: %@", reading.reading);
    NSDictionary *alarmInfo = @{
                                @"reading" : reading,
                                @"service" : self
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ServiceAlarm" object:self userInfo:alarmInfo];
}

- (BOOL) sendData:(NSDictionary *)readingData {
    __block BOOL dataSent = NO;
    NSError *jsonError;
    NSError *requestError;
    
    NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:readingData options:0 error:&jsonError];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *endpoint = @"/api/v1/entries";
    
    NSMutableDictionary *parameters = nil;
    if (self.roleToken && self.roleToken.length) {
        parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = self.roleToken;
    }
    
    NSURL *serviceBaseURL = [self serviceURL];
    if (serviceBaseURL) {
        NSURL *apiURL = [serviceBaseURL URLByAppendingPathComponent:endpoint];
        
        if (apiURL) {
            NSString *postString = [apiURL absoluteString];
            if (parameters != nil) {
                postString = [NSString stringWithFormat:@"%@?token=%@", [apiURL absoluteString], self.roleToken];
            }

            NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:postString parameters:parameters error:&requestError];
            request.timeoutInterval = 60.0;
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonRequest];
            
            [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil
                        completionHandler:^(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error) {
                            if (!error) {
                                dataSent = YES;
                            } else {
                                [[RLMRealm defaultRealm] beginWriteTransaction];
                                self.lastErrorCondition = [error localizedDescription];
                                [[RLMRealm defaultRealm] commitWriteTransaction];
                            }
                        }] resume];
        }
    }
    return dataSent;
}

- (BOOL)exportReadings:(RLMResults<GLUCReading *> *)readings ofType:(Class)readingType forUser:(GLUCUser *)user {
    BOOL result = YES;
    
    if (self.serviceEnabled) {
        for (GLUCReading *reading in readings) {
            NSLog(@"Posting to Nightscout: %@", reading);
            NSDictionary *readingDict = [reading dictionaryRepresentation];
            NSMutableDictionary *nightscoutDict = [NSMutableDictionary dictionary];
            
            NSDate *creationDate = readingDict[@"creationDate"];
            
            nightscoutDict[@"mbg"] = readingDict[@"reading"];
            nightscoutDict[@"date"] = [NSNumber numberWithLongLong:(long long)([creationDate timeIntervalSince1970] * 1000.0)];
            nightscoutDict[@"type"] = @"mbg";
            nightscoutDict[@"device"] = @"Glucosio App";
            
            result = [self sendData:nightscoutDict];
        }
    } else {
        NSLog(@"Service: %@ - disabled", self.serviceName);
    }

    return result;
}


- (BOOL) importReadingsOfType:(Class)readingType forUser:(GLUCUser *)user {
    __block BOOL dataLoaded = NO;
    
    if (![self.serviceEnabled boolValue]) {
        NSLog(@"Service: %@ -> Disabled", self.serviceName);
        return dataLoaded;
    }
    
    NSError *requestError;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *endpoint = @"/api/v1/entries";
    
    NSMutableDictionary *parameters = nil;
    if (self.roleToken && self.roleToken.length) {
        parameters = [NSMutableDictionary dictionary];
        parameters[@"token"] = self.roleToken;
    }
    
    NSURL *serviceBaseURL = [self serviceURL];
    if (serviceBaseURL) {
        NSURL *apiURL = [serviceBaseURL URLByAppendingPathComponent:endpoint];

        if (apiURL) {
            NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[apiURL absoluteString] parameters:parameters error:&requestError];
            request.timeoutInterval = 60.0;
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            
            [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil
                        completionHandler:^(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error) {
                            
                            if (!error) {
                                if ([responseObject isKindOfClass:[NSArray class]]) {
                                    NSArray *entries = (NSArray *)responseObject;
                                    if (entries && entries.count) {
                                        for (NSDictionary *entryDict in entries) {
                                            NSString *nightscoutID = entryDict[@"_id"];
                                            NSNumber *readingVal = entryDict[@"sgv"];
                                            if (!readingVal) {
                                                readingVal = entryDict[@"mbg"];
                                            }
                                            NSNumber *readingDateInMilliseconds = entryDict[@"date"];
                                            NSDate *readingDate = [NSDate dateWithTimeIntervalSince1970:([readingDateInMilliseconds longLongValue] / 1000.0)];
                                            
                                            NSString *readingTypeString = entryDict[@"type"];
                                            NSString *readingDirectionString = entryDict[@"direction"];
                                            
                                            BOOL isDupe = NO;
                                            if (nightscoutID && nightscoutID.length) {
                                                GLUCDataServiceReading *existingReading = [GLUCDataServiceReading objectForPrimaryKey:nightscoutID];
                                                if (existingReading) {
                                                    isDupe = YES;
                                                }
                                            }
                                            
                                            if (!isDupe && self.database) {
                                                NSMutableString *notesString = [NSMutableString stringWithString:@""];
                                                GLUCBloodGlucoseReading *newReading = [[GLUCBloodGlucoseReading alloc] init];
                                                newReading.creationDate = readingDate;
                                                newReading.reading = [NSNumber numberWithFloat:[readingVal floatValue]];
                                                if (readingTypeString && readingTypeString.length) {
                                                    [notesString appendFormat:@"%@: %@", GLUCLoc(@"Type: "), readingTypeString];
                                                }
                                                if (readingDirectionString && readingDirectionString.length) {
                                                    if (notesString.length) {
                                                        [notesString appendString:@", "];
                                                    }
                                                    [notesString appendFormat:@"%@ %@", GLUCLoc(@"Direction: "), readingDirectionString];
                                                }
                                                newReading.notes = notesString;
                                                
                                                if ([self.database saveReading:newReading fromService:self]) {
                                                    GLUCDataServiceReading *newDataServiceReading = [[GLUCDataServiceReading alloc] init];
                                                    newDataServiceReading.serviceName = self.serviceName;
                                                    newDataServiceReading.glucID = nightscoutID;
                                                    newDataServiceReading.glucReadingID = newReading.glucID;
                                                    newDataServiceReading.batchID = @0;
                                                    newDataServiceReading.creationDate = readingDate;
                                                    
                                                    [self.database saveObject:newDataServiceReading];
                                                    
                                                }
                                                
                                                dataLoaded = YES;
                                            }
                                        }
                                        if (dataLoaded) {
                                            [[RLMRealm defaultRealm] beginWriteTransaction];
                                            self.modificationDate = [NSDate date];
                                            [[RLMRealm defaultRealm] commitWriteTransaction];
                                            [self.database saveObject:self];
                                            
                                            GLUCBloodGlucoseReading *lastReading = (GLUCBloodGlucoseReading *)[self.database lastReadingOfType:[GLUCBloodGlucoseReading class]];
                                            
                                            [self triggerAlarmForReading:lastReading];
                                            
                                        }

                                    }
                                }
                            } else {
                                [[RLMRealm defaultRealm] beginWriteTransaction];
                                self.lastErrorCondition = [error localizedDescription];
                                NSLog(@"Error - %@", error);
                                [[RLMRealm defaultRealm] commitWriteTransaction];
                            }
                        }] resume];
            

        }
    }
    return dataLoaded;
}

@end
