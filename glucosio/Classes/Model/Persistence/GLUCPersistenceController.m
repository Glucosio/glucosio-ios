#import "GLUCPersistenceController.h"
#import "GLUCPersistenceDDL.h"
#import "NSCalendar+GLUCAdditions.h"
#import "NSFileManager+GLUCAdditions.h"

/*
 Current Database Schema as of 2016-03-26 (Mar 26 2016), as defined in Android app's Realm schema
 
 class User
 @PrimaryKey int id;
 String name;
 String preferred_language;
 String country;
 int age;
 String gender;
 int d_type;
 String preferred_unit;
 String preferred_range;
 int custom_range_min;
 int custom_range_max;
 
 class CholesterolReading
 @PrimaryKey long id;
 
 int totalReading;
 int LDLReading;
 int HDLReading;
 Date created;
 
 class GlucoseReading
 @PrimaryKey long id;
 
 int reading;
 String reading_type;
 String notes;
 int user_id;
 Date created;
 
 class KetoneReading
 @PrimaryKey long id;
 
 double reading;
 Date created;
 
 class PressureReading
 @PrimaryKey long id;
 
 int minReading;
 int maxReading;
 Date created;
 
 class WeightReading
 @PrimaryKey long id;
 
 int reading;
 Date created;
 
 class HB1ACReading
 @PrimaryKey long id;
 double reading; <-- Convert from int to double
 Date created;
 ************************************************/

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
        NSString *queryStr = [NSString stringWithFormat:@"SELECT MAX(reading_date) FROM %@", [GLUCBloodGlucoseReading entityName]];
        retVal = [self.db dateForQuery:queryStr];
    }
    
    return retVal;
}

- (int) lastRowId {
    int retVal = 0;
    if (self.db) {
        NSString *queryStr = [NSString stringWithFormat:@"SELECT MAX(reading_id) FROM %@", [GLUCBloodGlucoseReading entityName]];
        retVal = [self.db intForQuery:queryStr];
    }
    return retVal;
}

- (int) numberOfReadings {
    int retVal = 0;
    if (self.db) {
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(reading) FROM %@", [GLUCBloodGlucoseReading entityName]];
        retVal = [self.db intForQuery:queryStr];
    }
    return retVal;
}

- (void) execDDL {

    if (self.db) {
        NSLog(@"Creating reading table");
        NSString *createDDL = [GLUCPersistenceDDL createReadingTableNamed:[GLUCBloodGlucoseReading entityName]];
        NSLog(@"%@", createDDL);
        [self.db executeUpdate:createDDL];

#ifdef GLUC_CREATE_TEST_DATA
        for (int i = 0; i < 1000; ++i) {
            NSDate *today = [[NSCalendar currentCalendar] gluc_dateByAddingMonths:(arc4random_uniform(12)*-1) toDate:[NSDate date]];
            NSDate *readingDate = [[NSCalendar currentCalendar] gluc_dateByAddingDays:(arc4random_uniform(45)*-1) toDate:today];
            int reading = arc4random_uniform(30) + 70;
            NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO %@ (reading, reading_date,reading_type) VALUES(?,?,?)", [GLUCBloodGlucoseReading entityName]];
            [self.db executeUpdate:queryStr,
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
            aUser.preferredBloodGlucoseUnitOfMeasure = [standardDefaults valueForKey:kGLUCUserPreferredBloodGlucoseUnitsPropertyKey];
            aUser.preferredBodyWeightUnitOfMeasure = [standardDefaults valueForKey:kGLUCUserPreferredBodyWeightUnitsPropertyKey];
            aUser.preferredA1CUnitOfMeasure = [standardDefaults valueForKey:kGLUCUserPreferredA1CUnitsPropertyKey];
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
            if (aUser.preferredBloodGlucoseUnitOfMeasure) {
                [defaults setValue:aUser.preferredBloodGlucoseUnitOfMeasure forKey:kGLUCUserPreferredBloodGlucoseUnitsPropertyKey];
            }
            if (aUser.preferredBodyWeightUnitOfMeasure) {
                [defaults setValue:aUser.preferredBodyWeightUnitOfMeasure forKey:kGLUCUserPreferredBodyWeightUnitsPropertyKey];
            }
            if (aUser.preferredA1CUnitOfMeasure) {
                [defaults setValue:aUser.preferredA1CUnitOfMeasure forKey:kGLUCUserPreferredA1CUnitsPropertyKey];
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

- (BOOL)saveBloodGlucoseReading:(GLUCBloodGlucoseReading *)reading {
    if (reading && reading.value) {
        if ([reading.glucId intValue] == -1) {
            NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO %@ (reading,reading_date,reading_type) VALUES(?,?,?)", [[reading class] entityName]];
            [self.db executeUpdate:queryStr,
                    reading.value, reading.creationDate, reading.readingTypeId, nil];
        } else {
            NSString *queryStr = [NSString stringWithFormat:@"UPDATE %@ set reading = ?, reading_date = ?, reading_type = ? WHERE reading_id = ?", [[reading class] entityName]];
            [self.db executeUpdate:queryStr,
                    reading.value, reading.creationDate, reading.readingTypeId, reading.glucId, nil];
        }
    }
    return YES;
}

- (BOOL)deleteBloodGlucoseReading:(GLUCBloodGlucoseReading *)reading {
    if (reading) {
        if ([reading.glucId intValue] != -1) {
            NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM %@ where reading_id = ?", [[reading class] entityName]];
            [self.db executeUpdate:queryStr, reading.glucId, nil];
        }
    }
    return YES;
}

- (void)fillBloodGlucoseReading:(GLUCBloodGlucoseReading *)aReading fromResults:(FMResultSet *) results {
    if (aReading && results) {
        aReading.glucId = @([results intForColumn:@"reading_id"]);
        aReading.value = [NSNumber numberWithInt:[results intForColumn:@"reading"]];
        aReading.readingTypeId = @([results intForColumn:@"reading_type"]);
        aReading.creationDate = [results dateForColumn:@"reading_date"];
        aReading.ownerId = @1;
        aReading.notes = [results stringForColumn:@"notes"];
    }
}

- (NSArray *)allBloodGlucoseReadings:(BOOL)ascending {
    NSMutableArray *readings = [NSMutableArray array];
    FMResultSet *results = nil;
    NSString *queryStr = @"";
    
    if (ascending) {
        queryStr = [NSString stringWithFormat:@"SELECT * from %@ order by datetime(reading_date)", [GLUCBloodGlucoseReading entityName]];
        results = [self.db executeQuery:queryStr];
    } else {
        queryStr = [NSString stringWithFormat:@"SELECT * from %@ order by datetime(reading_date) DESC", [GLUCBloodGlucoseReading entityName]];
        results = [self.db executeQuery:queryStr];
    }
    while ([results next]) {
        GLUCBloodGlucoseReading *reading = [[GLUCBloodGlucoseReading alloc] init];

        [self fillBloodGlucoseReading:reading fromResults:results];
        [readings addObject:reading];
    }
    
    return (NSArray *)readings;
}

- (GLUCBloodGlucoseReading *)lastBloodGlucoseReading {
    GLUCBloodGlucoseReading *retVal = nil;
    FMResultSet *results = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * from %@ where reading_date = ?", [GLUCBloodGlucoseReading entityName]], [self mostRecentDate]];
    while ([results next]) {
        GLUCBloodGlucoseReading *reading = [[GLUCBloodGlucoseReading alloc] init];

        [self fillBloodGlucoseReading:reading fromResults:results];

        retVal = reading;
    }
    return retVal;
}

- (void) saveAll {
    [self saveUser:self.currentUser];
}

@end
