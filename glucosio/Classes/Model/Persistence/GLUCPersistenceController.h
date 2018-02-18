#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GLUCUser.h"
#import "GLUCReading.h"
#import "GLUCBloodGlucoseReading.h"

#import <Realm/Realm.h>

@class GLUCDataService;

// Increment this for each schema change
static NSInteger const kGLUCModelSchemaVersion = 2;

@protocol GLUCDatabase
- (BOOL)saveReading:(GLUCReading *)reading fromService:(GLUCDataService *)importService;
- (void)saveObject:(RLMObject *)anObject;
- (GLUCReading *) lastReadingOfType:(Class)readingType;
- (void)cancelWriteTransaction;
- (GLUCUser *) currentUser;
@end

@interface GLUCPersistenceController : NSObject <GLUCDatabase>

//@property (strong, nonatomic) FMDatabase *db;

- (instancetype) init;

// Initial setup
- (void) configureModel;
- (BOOL) configureServices;

- (GLUCUser *) currentUser; // creates one if needed
- (BOOL) saveUser:(GLUCUser *)aUser;
- (BOOL) deleteUser:(GLUCUser *)aUser;

// create reading
- (BOOL)saveReading:(GLUCReading *)reading fromService:(GLUCDataService *)service;
- (BOOL)deleteReading:(GLUCReading *)reading;

- (RLMResults<GLUCReading *> *)allReadingsOfType:(Class)readingType sortByDateAscending:(BOOL)ascending;

- (RLMResults<GLUCReading *> *)readingsOfType:(Class)readingType fromDate:(NSDate *)from toDate:(NSDate *)to sortByDateAscending:(BOOL)ascending;

- (GLUCReading *)lastReadingOfType:(Class)readingType;

- (GLUCReading *)firstReadingOfType:(Class)readingType;

- (RLMResults <GLUCBloodGlucoseReading *> *)allBloodGlucoseReadings:(BOOL)ascending;

- (GLUCBloodGlucoseReading *)lastBloodGlucoseReading;

- (void) saveAll;

- (void) exportAll;

- (void) import;

- (BOOL) nightscoutAvailable;
- (void) refreshFromServices;

@end
