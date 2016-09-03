//
//  GraphDataSource.h
//  glucosio
//
//  Created by Eugenio Baglieri on 03/09/16.
//  Copyright © 2016 Glucosio.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUCPersistenceController.h"
#import "GraphPoint.h"

@interface GraphDataGenerator : NSObject

@property (strong, readonly) GLUCPersistenceController *modelController;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithModeController:(GLUCPersistenceController *)persistence;

- (NSArray<GraphPoint *> *)graphPointsForReadingType:(Class)readingType;

@end
