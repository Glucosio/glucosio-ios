//
//  GraphDataSource.m
//  glucosio
//
//  Created by Eugenio Baglieri on 03/09/16.
//  Copyright © 2016 Glucosio.org. All rights reserved.
//

#import "GLUCGraphDataGenerator.h"
#import "GLUCReading.h"
#import "GLUCGraphPoint.h"
#import "NSCalendar+GLUCAdditions.h"
#import "NSDate+GLUCAdditions.h"
#import "NSDateComponents+GLUCAdditions.h"

@implementation GLUCGraphDataGenerator

#pragma mark - Inits

- (instancetype)initWithModeController:(GLUCPersistenceController *)persistence {
    
    self  = [super init];
    if (self != nil) {
        _modelController = persistence;
    }
    
    return self;
}

- (NSArray<GLUCGraphPoint *> *)graphPointsForReadingType:(Class)readingType {
    
    NSMutableArray<GLUCGraphPoint *> *points = [NSMutableArray array];
    
    if ([readingType isSubclassOfClass:[GLUCReading class]]) {
        
        RLMResults<GLUCReading *> *readings = [self.modelController allReadingsOfType:readingType sortByDateAscending:YES];
        
        for (GLUCReading *reading in readings) {
            GLUCGraphPoint *point = [[GLUCGraphPoint alloc] init];
            
            point.x = reading.creationDate;
            
            if (readingType == [GLUCBloodGlucoseReading class]) {
                GLUCUser *user = self.modelController.currentUser;
                NSNumber *readingValueInPreferredUnit = [user bloodGlucoseReadingValueInPreferredUnits:(GLUCBloodGlucoseReading *)reading];
                point.y = [readingValueInPreferredUnit doubleValue];
            } else {
                point.y = [reading.reading doubleValue];
            }
            
            [points addObject:point];
        }
    }
    
    return [points copy];
}

- (NSArray<GLUCGraphPoint *> *)weeklyAverageGraphPointsForReadingType:(Class)readingType {
    
    NSMutableArray<GLUCGraphPoint *> *points = [NSMutableArray array];
    
    // Use same date technique for averaging as Glucosio for Android
    
    NSDate *maxDate = [self.modelController lastReadingOfType:readingType].creationDate;
    NSDate *minDate = [self.modelController firstReadingOfType:readingType].creationDate;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger weeksBetween = [cal gluc_weeksBetween:minDate andDate:maxDate] + 1;
    
    for (NSInteger weekIndex = 0; weekIndex < weeksBetween; ++weekIndex) {
        NSDate *startDate = [cal gluc_dateByAddingWeeks:weekIndex toDate:minDate];
        NSDate *endDate = [cal gluc_dateByAddingWeeks:1 toDate:startDate];
        
        RLMResults<GLUCReading *> *readings = [self.modelController readingsOfType:readingType fromDate:startDate toDate:endDate sortByDateAscending:YES];
        
        GLUCGraphPoint *point = [[GLUCGraphPoint alloc] init];
        
        NSNumber *averageValue = [readings averageOfProperty:@"reading"];
        
        if (readingType == [GLUCBloodGlucoseReading class]) {
            GLUCUser *user = self.modelController.currentUser;
            GLUCBloodGlucoseReading *tempReading = [[GLUCBloodGlucoseReading alloc] init];
            tempReading.reading = averageValue;
            NSNumber *readingValueInPreferredUnit = [user bloodGlucoseReadingValueInPreferredUnits:(GLUCBloodGlucoseReading *)tempReading];
            point.y = [readingValueInPreferredUnit doubleValue];
        } else {
            point.y = averageValue.doubleValue;
        }
        
        point.x = startDate;
        
        [points addObject:point];
    }
    
    return [points copy];
}

- (NSArray<GLUCGraphPoint *> *)montlyAverageGraphPointsForReadingType:(Class)readingType {

    NSMutableArray<GLUCGraphPoint *> *points = [NSMutableArray array];
    
    // Use same date technique for averaging as Glucosio for Android
    
    NSDate *maxDate = [self.modelController lastReadingOfType:readingType].creationDate;
    NSDate *minDate = [self.modelController firstReadingOfType:readingType].creationDate;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger monthsBetween = [cal gluc_monthsBetween:minDate andDate:maxDate] + 1;
    
    for (NSInteger monthIndex = 0; monthIndex < monthsBetween; ++monthIndex) {
        NSDate *startDate = [cal gluc_dateByAddingMonths:monthIndex toDate:minDate];
        NSDate *endDate = [cal gluc_dateByAddingMonths:1 toDate:startDate];
        
        RLMResults<GLUCReading *> *readings = [self.modelController readingsOfType:readingType fromDate:startDate toDate:endDate sortByDateAscending:YES];
        
        GLUCGraphPoint *point = [[GLUCGraphPoint alloc] init];
        
        NSNumber *averageValue = [readings averageOfProperty:@"reading"];
        
        if (readingType == [GLUCBloodGlucoseReading class]) {
            GLUCUser *user = self.modelController.currentUser;
            GLUCBloodGlucoseReading *tempReading = [[GLUCBloodGlucoseReading alloc] init];
            tempReading.reading = averageValue;
            NSNumber *readingValueInPreferredUnit = [user bloodGlucoseReadingValueInPreferredUnits:(GLUCBloodGlucoseReading *)tempReading];
            point.y = [readingValueInPreferredUnit doubleValue];
        } else {
            point.y = averageValue.doubleValue;
        }
        
        point.x = startDate;
        
        [points addObject:point];
    }
    
    return [points copy];
}


@end
