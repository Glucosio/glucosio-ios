#import <Realm/RLMResults.h>
#import <Realm/RLMRealm.h>
#import "GLUCPersistenceController.h"
#import "NSCalendar+GLUCAdditions.h"
#import "GLUCBodyWeightReading.h"
#import "GLUCBloodPressureReading.h"
#import "GLUCCholesterolReading.h"
#import "GLUCHbA1cReading.h"
#import "GLUCInsulinIntakeReading.h"
#import "GLUCKetonesReading.h"
#import "GLUCBloodGlucoseReading.h"
#import <CHCSVParser/CHCSVParser.h>
#import <SSZipArchive/SSZipArchive.h>

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
 
 class HbA1cReading
 @PrimaryKey long id;
 double reading; <-- Convert from int to double
 Date created;
 ************************************************/

#define GLUC_CREATE_TEST_DATA

@interface GLUCPersistenceController ()
@property(strong, nonatomic, readwrite) GLUCUser *user;
@end

@implementation GLUCPersistenceController

- (instancetype)init {
    if ((self = [super init]) != nil) {
    }
    return self;
}

- (void)insertSampleReadingsOfType:(Class)readingType {
    for (int i = 0; i < 100; ++i) {
        NSDate *today = [[NSCalendar currentCalendar] gluc_dateByAddingMonths:(arc4random_uniform(12) * -1) toDate:[NSDate date]];
        NSDate *readingDate = [[NSCalendar currentCalendar] gluc_dateByAddingDays:(arc4random_uniform(45) * -1) toDate:today];
        double reading = arc4random_uniform(30) + 110;
        GLUCReading *dummyReading = [[readingType alloc] init];
        if (dummyReading) {
            dummyReading.reading = (id)[NSNumber numberWithDouble:reading];
            dummyReading.creationDate = readingDate;
            dummyReading.modificationDate = readingDate;
            [self saveReading:dummyReading];
        }
    }

}

- (void)execDDL {
#ifdef GLUC_CREATE_TEST_DATA

    NSArray *standardReadingTypes = @[
            GLUCBloodPressureReading.class,
            GLUCBodyWeightReading.class,
            GLUCCholesterolReading.class,
            GLUCHbA1cReading.class,
            GLUCInsulinIntakeReading.class,
            GLUCKetonesReading.class
    ];


    // create some test blood glucose readings
    for (int i = 0; i < 1000; ++i) {
        NSDate *today = [[NSCalendar currentCalendar] gluc_dateByAddingMonths:(arc4random_uniform(12) * -1) toDate:[NSDate date]];
        NSDate *readingDate = [[NSCalendar currentCalendar] gluc_dateByAddingDays:(arc4random_uniform(45) * -1) toDate:today];
        int reading = arc4random_uniform(110) + 70;
        GLUCBloodGlucoseReading *testReading = [[GLUCBloodGlucoseReading alloc] init];
        if (testReading) {
            testReading.reading = (id)[NSNumber numberWithInt:reading];
            testReading.readingTypeId = (id)@(arc4random_uniform(9));
            testReading.creationDate = readingDate;
            testReading.modificationDate = readingDate;
            [self saveReading:testReading];
        }
    }
    // create some other standard readings
    for (Class readingClass in standardReadingTypes) {
        [self insertSampleReadingsOfType:readingClass];
        NSLog(@"Created %lu readings of type: %@", (unsigned long)[[readingClass allObjects] count], NSStringFromClass(readingClass));
    }
#endif
}


// Initial setup
- (void)configureModel {
    
    // Perform any required schema migrations...
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = kGLUCModelSchemaVersion;
    
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < kGLUCModelSchemaVersion) {
            // Nothing to do yet
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
    
    RLMResults<GLUCBloodGlucoseReading *> *blood_glucose_readings = [GLUCBloodGlucoseReading allObjects];

    if (blood_glucose_readings.count == 0) {
        [self execDDL];
    }
}

// CRUD operations
- (BOOL)loadUser:(GLUCUser *)aUser {
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
            aUser.allowResearchUse = (id)@([standardDefaults boolForKey:kGLUCUserAllowResearchUsePropertyKey]);
        }
    }
    return retVal;
}

- (GLUCUser *)currentUser { // creates one if new
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

- (BOOL)saveUser:(GLUCUser *)aUser {
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

- (BOOL)deleteUser:(GLUCUser *)aUser {
    BOOL retVal = NO;
    if (self.user) {
        // reset values in persistent store
        retVal = YES;
    }
    return retVal;
}

// read, update, delete reading

- (BOOL)saveReading:(GLUCReading *)reading {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:reading];
    [realm commitWriteTransaction];

    return YES;
}

- (BOOL)deleteReading:(GLUCBloodGlucoseReading *)reading {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObject:reading];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    return YES;
}


- (RLMResults <GLUCReading *> *)allReadingsOfType:(Class)readingType sortByDateAscending:(BOOL)ascending {
    RLMResults <GLUCReading *> *allReadings = [[readingType allObjects] sortedResultsUsingKeyPath:@"creationDate" ascending:ascending];

    return allReadings;
}

- (RLMResults <GLUCReading *> *)readingsOfType:(Class)readingType fromDate:(NSDate *)from toDate:(NSDate *)to sortByDateAscending:(BOOL)ascending {
    
    NSAssert([readingType isSubclassOfClass:[RLMObject class]], @"Error: reading type must me a subclass of RLMObject");
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creationDate BETWEEN {%@, %@}", from, to];
    RLMResults <GLUCReading *> *readings = [[readingType objectsWithPredicate:predicate]
                                            sortedResultsUsingKeyPath:@"creationDate" ascending:ascending];
    
    return readings;
}

- (RLMResults <GLUCBloodGlucoseReading *> *)allBloodGlucoseReadings:(BOOL)ascending {
    RLMResults <GLUCBloodGlucoseReading *> *allReadings = [[GLUCBloodGlucoseReading allObjects] sortedResultsUsingKeyPath:@"creationDate" ascending:NO];
    return allReadings;
}

- (GLUCReading *)lastReadingOfType:(Class)readingType {
    
    NSAssert([readingType isSubclassOfClass:[RLMObject class]], @"Error: reading type must me a subclass of RLMObject");
    
    RLMResults <GLUCReading *> *allReadings = [[readingType allObjects] sortedResultsUsingKeyPath:@"creationDate" ascending:NO];
    return [allReadings firstObject];
}

- (GLUCReading *)firstReadingOfType:(Class)readingType {
    
    NSAssert([readingType isSubclassOfClass:[RLMObject class]], @"Error: reading type must me a subclass of RLMObject");
    
    RLMResults <GLUCReading *> *allReadings = [[readingType allObjects] sortedResultsUsingKeyPath:@"creationDate" ascending:NO];
    return [allReadings lastObject];
}

- (GLUCBloodGlucoseReading *)lastBloodGlucoseReading {
    RLMResults <GLUCBloodGlucoseReading *> *allReadings = [[GLUCBloodGlucoseReading allObjects] sortedResultsUsingKeyPath:@"creationDate" ascending:NO];
    return [allReadings firstObject];
}

- (void)saveAll {
    [self saveUser:self.currentUser];
}


// From the Android app, https://github.com/Glucosio/glucosio-android/blob/develop/app/src/main/java/org/glucosio/android/tools/ReadingToCSV.java
//
// CSV Structure:
//
// 1. Date | Time | Concentration | Unit | Measured | Notes
// ... one line
//
// 2. Concentration | Measured | Date | Time | Notes | Unit of Measurement
// ... for each reading
//
// Actual field order is:
// Created Date | Created Time | Concentration Value | Unit of Measurement | (What was) Measured | Notes
// where unit of measurement is "mg/dL" or "mmol/L" and the concentration is converted.
//
// Note how the Android export is not complete. Most readings are not exported.
- (void) exportAll {
    [self exportAllToZipUsingCSV];
}

- (void) exportAllToZipUsingCSV {
    NSDateFormatter *iso8601DateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [iso8601DateFormatter setLocale:enUSPOSIXLocale];
    [iso8601DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *outputFolder = [documentsDirectory stringByAppendingPathComponent:@"/Export"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:outputFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:outputFolder withIntermediateDirectories:NO attributes:nil error:&error];
    }
    NSArray * readingTypes = [self.currentUser readingTypes];
    for(int i=0; i < readingTypes.count; i++) {
        Class clazz = (Class) readingTypes[i];
        NSString * table = NSStringFromClass(clazz);
        NSString *filename = [NSString stringWithFormat:@"/%@.csv", table];
        NSString *outputFile = [outputFolder stringByAppendingPathComponent:filename];
        CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToCSVFile:outputFile];
        if (writer) {
            RLMResults <GLUCReading *> * data = [self allReadingsOfType:clazz sortByDateAscending:YES];
            for(int k = 0;k < data.count; k++) {
                GLUCReading * r = data[k];
                [writer writeLineOfFields:@[[iso8601DateFormatter stringFromDate:r.creationDate], r.reading, r.notes]];
            }
            [writer closeStream];
        }
    }
    
    NSString *zipFilePath = [documentsDirectory stringByAppendingPathComponent:@"/Data.zip"];
    
    [SSZipArchive createZipFileAtPath:zipFilePath withContentsOfDirectory:outputFolder keepParentDirectory:YES];
}


@end
