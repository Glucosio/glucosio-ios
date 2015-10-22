#import "GLUCPersistenceController.h"
#import "GLUCPersistenceDDL.h"
#import "NSCalendar+GLUCAdditions.h"
#import "NSFileManager+GLUCAdditions.h"

#define GLUC_CREATE_TEST_DATA

@interface GLUCPersistenceController()
@property (strong, nonatomic, readwrite) GLUCUser *user;
@end

@implementation GLUCPersistenceController

- (instancetype) init {
    if ((self = [super init]) != nil) {
    }
    return self;
}

- (NSDate *) mostRecentDate {
    NSDate *retVal = nil;

    if (self.db) {
        retVal = [self.db dateForQuery:@"SELECT MAX(reading_date) FROM reading"];
    }
    
    return retVal;
}

- (int) lastRowId {
    int retVal = 0;
    if (self.db) {
        retVal = [self.db intForQuery:@"SELECT MAX(reading_id) FROM reading"];
    }
    return retVal;
}

- (int) numberOfReadings {
    int retVal = 0;
    if (self.db) {
        retVal = [self.db intForQuery:@"SELECT COUNT(reading) FROM reading"];
    }
    return retVal;
}

- (void) execDDL {
    if (self.db) {
        NSLog(@"Creating reading table");
        NSString *createDDL = [GLUCPersistenceDDL createReadingTable];
        NSLog(@"%@", createDDL);
        [self.db executeUpdate:createDDL];

#ifdef GLUC_CREATE_TEST_DATA
        for (int i = 0; i < 1000; ++i) {
            NSDate *today = [[NSCalendar currentCalendar] gluc_dateByAddingMonths:(arc4random_uniform(12)*-1) toDate:[NSDate date]];
            NSDate *readingDate = [[NSCalendar currentCalendar] gluc_dateByAddingDays:(arc4random_uniform(45)*-1) toDate:today];
            int reading = arc4random_uniform(30) + 70;
            [self.db executeUpdate:@"INSERT INTO reading (reading,reading_date,reading_type) VALUES(?,?,?)",
             @(reading), [[NSCalendar currentCalendar] gluc_dateByAddingMinutes:(arc4random_uniform(58)) toDate:readingDate], @(arc4random_uniform(9)), nil];
        }
#endif
        NSLog(@"Readings: %d", [self numberOfReadings]);
    }
}


- (NSString *) databasePath {
    return [[NSFileManager defaultManager] gluc_documentPathForFileWithName:@"glucosio_db" andExtension:@"sqlite"];
}

// Initial setup
- (void) configureModel {
    // setup
    if (!self.db) {
        self.db = [FMDatabase databaseWithPath:[self databasePath]];
        if (self.db) {
            if (![self.db open]) {
                self.db = nil;
            } else {
                int count = [self numberOfReadings];
                if (count == 0) {
                    [self execDDL];
                }
                else {
                    NSLog(@"%d readings, last row id = %d", count, [self lastRowId]);
                }
            }
        }
    }
}

// CRUD operations
- (BOOL) loadUser:(GLUCUser *)aUser {
    BOOL retVal = NO;
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    if (standardDefaults) {
        NSDate *creationDate = [standardDefaults valueForKey:kGLUCModelCreationDateKey];
        if (creationDate) {
            retVal = YES;
            aUser.creationDate = creationDate;
            aUser.modificationDate = [standardDefaults valueForKey:kGLUCModelModificationDateKey];
            aUser.countryPreference = [standardDefaults valueForKey:kGLUCUserCountryPreferenceKey];
            aUser.age = [standardDefaults valueForKey:kGLUCUserAgePropertyKey];
            aUser.gender = [standardDefaults valueForKey:kGLUCUserGenderPropertyKey];
            aUser.illnessType = [standardDefaults valueForKey:kGLUCUserIllnessTypePropertyKey];
            aUser.preferredUnifOfMeasure = [standardDefaults valueForKey:kGLUCUserPreferredUnitsPropertyKey];
            aUser.rangeType = [standardDefaults valueForKey:kGLUCUserRangeTypePropertyKey];
            aUser.rangeMin = [standardDefaults valueForKey:kGLUCUserRangeMinPropertyKey];
            aUser.rangeMax = [standardDefaults valueForKey:kGLUCUserRangeMaxPropertyKey];
            aUser.allowResearchUse = @([standardDefaults boolForKey:kGLUCUserAllowResearchUsePropertyKey]);
        }
    }
    return retVal;
}

- (GLUCUser *) currentUser { // creates one if new
    if (!self.user) {
        self.user = [[GLUCUser alloc] init];
        
        if (self.user) {
            BOOL existingUser = [self loadUser:self.user];
            if (!existingUser) {
                [self.user setValue:[NSDate date] forKey:@"creationDate"];
            }
        }
    }
    return self.user;
}

- (BOOL) saveUser:(GLUCUser *)aUser {
    BOOL retVal = NO;

    if (self.user) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (defaults) {
            if (aUser.creationDate) {
                [defaults setValue:aUser.creationDate forKey:kGLUCModelCreationDateKey];
            }
            if (aUser.modificationDate) {
                [defaults setValue:aUser.modificationDate forKey:kGLUCModelModificationDateKey];
            }
            
            if (aUser.countryPreference && aUser.countryPreference.length) {
                [defaults setValue:aUser.countryPreference forKey:kGLUCUserCountryPreferenceKey];
            }
            if (aUser.age) {
                [defaults setValue:aUser.age forKey:kGLUCUserAgePropertyKey];
            }
            if (aUser.gender) {
                [defaults setValue:aUser.gender forKey:kGLUCUserGenderPropertyKey];
            }
            if (aUser.illnessType) {
                [defaults setValue:aUser.illnessType forKey:kGLUCUserIllnessTypePropertyKey];
            }
            if (aUser.preferredUnifOfMeasure) {
                [defaults setValue:aUser.preferredUnifOfMeasure forKey:kGLUCUserPreferredUnitsPropertyKey];
            }
            if (aUser.rangeType) {
                [defaults setValue:aUser.rangeType forKey:kGLUCUserRangeTypePropertyKey];
            }
            if (aUser.rangeMin) {
                [defaults setValue:aUser.rangeMin forKey:kGLUCUserRangeMinPropertyKey];
            }
            if (aUser.rangeMax) {
                [defaults setValue:aUser.rangeMax forKey:kGLUCUserRangeMaxPropertyKey];
            }
            
            [defaults setBool:[aUser.allowResearchUse boolValue] forKey:kGLUCUserAllowResearchUsePropertyKey];
            
            [defaults synchronize];
            
            retVal = YES;
        } else {
            retVal = NO;
        }
    }

    return retVal;
}

- (BOOL) deleteUser:(GLUCUser *)aUser {
    BOOL retVal = NO;
    if (self.user) {
        // reset values in persistent store
        retVal = YES;
    }
    return retVal;
}

// read, update, delete reading

- (BOOL) saveReading:(GLUCReading *)reading {
    if (reading && reading.value) {
        if ([reading.glucId intValue] == -1) {
            [self.db executeUpdate:@"INSERT INTO reading (reading,reading_date,reading_type) VALUES(?,?,?)",
                    reading.value, reading.creationDate, reading.readingTypeId, nil];
        } else {
            [self.db executeUpdate:@"UPDATE reading set reading = ?, reading_date = ?, reading_type = ? WHERE reading_id = ?",
                    reading.value, reading.creationDate, reading.readingTypeId, reading.glucId, nil];
        }
    }
    return YES;
}

- (BOOL) deleteReading:(GLUCReading *)reading {
    if (reading) {
        if ([reading.glucId intValue] != -1) {
            [self.db executeUpdate:@"DELETE FROM reading where reading_id = ?", reading.glucId, nil];
        }
    }
    return YES;
}

- (void) fillReading:(GLUCReading *)aReading fromResults:(FMResultSet *) results {
    if (aReading && results) {
        aReading.glucId = @([results intForColumn:@"reading_id"]);
        aReading.value = [NSNumber numberWithInt:[results intForColumn:@"reading"]];
        aReading.readingTypeId = @([results intForColumn:@"reading_type"]);
        aReading.creationDate = [results dateForColumn:@"reading_date"];
        aReading.ownerId = @1;
        aReading.notes = [results stringForColumn:@"notes"];
    }
}

- (NSArray *) allReadings:(BOOL)ascending {
    NSMutableArray *readings = [NSMutableArray array];
    FMResultSet *results = nil;
    
    if (ascending) {
        results = [self.db executeQuery:@"SELECT * from reading order by datetime(reading_date)"];
    } else {
        results = [self.db executeQuery:@"SELECT * from reading order by datetime(reading_date) DESC"];
    }
    while ([results next]) {
        GLUCReading *reading = [[GLUCReading alloc] init];

        [self fillReading:reading fromResults:results];
        [readings addObject:reading];
    }
    
    return (NSArray *)readings;
}

- (GLUCReading *) lastReading {
    GLUCReading *retVal = nil;
    FMResultSet *results = [self.db executeQuery:@"SELECT * from reading where reading_date = ?", [self mostRecentDate]];
    while ([results next]) {
        GLUCReading *reading = [[GLUCReading alloc] init];

        [self fillReading:reading fromResults:results];

        retVal = reading;
    }
    return retVal;
}

- (void) saveAll {
    [self saveUser:self.currentUser];
}

@end
