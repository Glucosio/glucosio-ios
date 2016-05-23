#import <Realm/RLMResults.h>
#import <Realm/RLMRealm.h>
#import "GLUCPersistenceController.h"
#import "NSCalendar+GLUCAdditions.h"
#import "GLUCBodyWeightReading.h"
#import "GLUCBloodPressureReading.h"
#import "GLUCCholesterolReading.h"
#import "GLUCHB1ACReading.h"
#import "GLUCInsulinIntakeReading.h"
#import "GLUCKetonesReading.h"
#import "GLUCBloodGlucoseReading.h"

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

//#define GLUC_CREATE_TEST_DATA

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
            GLUCHB1ACReading.class,
            GLUCInsulinIntakeReading.class,
            GLUCKetonesReading.class
    ];


    // create some test blood glucose readings
    for (int i = 0; i < 1000; ++i) {
        NSDate *today = [[NSCalendar currentCalendar] gluc_dateByAddingMonths:(arc4random_uniform(12) * -1) toDate:[NSDate date]];
        NSDate *readingDate = [[NSCalendar currentCalendar] gluc_dateByAddingDays:(arc4random_uniform(45) * -1) toDate:today];
        int reading = arc4random_uniform(30) + 70;
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


- (RLMResults <GLUCReading *> *)allReadingsOfType:(Class)readingType {
    RLMResults <GLUCReading *> *allReadings = [[readingType allObjects] sortedResultsUsingProperty:@"creationDate" ascending:NO];

    return allReadings;
}

- (RLMResults <GLUCBloodGlucoseReading *> *)allBloodGlucoseReadings:(BOOL)ascending {
    RLMResults <GLUCBloodGlucoseReading *> *allReadings = [[GLUCBloodGlucoseReading allObjects] sortedResultsUsingProperty:@"creationDate" ascending:NO];
    return allReadings;
}

- (GLUCBloodGlucoseReading *)lastBloodGlucoseReading {
    RLMResults <GLUCBloodGlucoseReading *> *allReadings = [[GLUCBloodGlucoseReading allObjects] sortedResultsUsingProperty:@"creationDate" ascending:NO];
    return [allReadings firstObject];
}

- (void)saveAll {
    [self saveUser:self.currentUser];
}

@end
