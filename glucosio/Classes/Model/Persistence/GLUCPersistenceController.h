#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GLUCUser.h"
#import "GLUCReading.h"
#import "GLUCBloodGlucoseReading.h"
#import <FMDB/FMDB.h>

@interface GLUCPersistenceController : NSObject

@property (strong, nonatomic) FMDatabase *db;

- (instancetype) init;

// Initial setup
- (void) configureModel;

- (GLUCUser *) currentUser; // creates one if needed
- (BOOL) saveUser:(GLUCUser *)aUser;
- (BOOL) deleteUser:(GLUCUser *)aUser;

// create reading
- (BOOL)saveReading:(GLUCReading *)reading;
- (BOOL)deleteReading:(GLUCReading *)reading;

- (NSArray *)allBloodGlucoseReadings:(BOOL)ascending;
- (GLUCBloodGlucoseReading *)lastBloodGlucoseReading;

- (void) saveAll;

@end
