//
//  GraphDataSource.m
//  glucosio
//
//  Created by Eugenio Baglieri on 03/09/16.
//  Copyright © 2016 Glucosio.org. All rights reserved.
//

#import "GraphDataGenerator.h"
#import "GLUCReading.h"
#import "GraphPoint.h"
#import "NSCalendar+GLUCAdditions.h"
#import "NSDate+GLUCAdditions.h"
#import "NSDateComponents+GLUCAdditions.h"

@implementation GraphDataGenerator

#pragma mark - Inits

- (instancetype)initWithModeController:(GLUCPersistenceController *)persistence {
    
    self  = [super init];
    if (self != nil) {
        _modelController = persistence;
    }
    
    return self;
}

- (NSArray<GraphPoint *> *)graphPointsForReadingType:(Class)readingType {
    
    NSMutableArray<GraphPoint *> *points = [NSMutableArray array];
    
    if ([readingType isSubclassOfClass:[GLUCReading class]]) {
        
        RLMResults<GLUCReading *> *readings = [self.modelController allReadingsOfType:readingType sortByDateAscending:NO];
        
        for (GLUCReading *reading in readings) {
            GraphPoint *point = [[GraphPoint alloc] init];
            point.x = reading.creationDate;
            point.y = [reading.reading doubleValue];
            [points addObject:point];
        }
    }
    
    return [points copy];
}


@end
