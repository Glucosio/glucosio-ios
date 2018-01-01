//
// Created by Chris Walters on 4/10/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Realm/Realm.h>
#import "GLUCReading.h"
#import "UIColor+GLUCAdditions.h"


@implementation GLUCReading {

}

+ (NSDictionary *)schema {
    NSDictionary *propertiesDict = @{
            kGLUCReadingModelValuePropertyKey : @{
                    kGLUCModelAttributeKey : kGLUCReadingModelValuePropertyKey,
                    kGLUCModelAttributeTitleKey : @"dialog_add_concentration",
                    kGLUCModelAttributeTypeKey : @"NSNumber",
            },
            kGLUCReadingNotesPropertyKey : @{
                    kGLUCModelAttributeKey : kGLUCReadingNotesPropertyKey,
                    kGLUCModelAttributeTitleKey : @"Notes",
                    kGLUCModelAttributeTypeKey : @"NSString"
            },
            kGLUCModelCreationDatePropertyKey : @{
                    kGLUCModelAttributeKey : kGLUCModelCreationDateKey,
                    kGLUCModelAttributeTitleKey : @"dialog_add_date",
                    kGLUCModelAttributeTypeKey : kGLUCModelAttributeDateTypeKey
            },
            kGLUCModelCreationTimePropertyKey : @{
                    kGLUCModelAttributeKey : kGLUCModelCreationDateKey,
                    kGLUCModelAttributeTitleKey : @"dialog_add_time",
                    kGLUCModelAttributeTypeKey : kGLUCModelAttributeTimeTypeKey
            },

    };

    return @{
            kGLUCModelSettingsPropertiesKey : @[kGLUCReadingModelValuePropertyKey,
                    kGLUCModelCreationDateKey, kGLUCReadingNotesPropertyKey],

            kGLUCModelSchemaPropertiesKey : propertiesDict,

            kGLUCModelEditorRowsPropertiesKey : @[kGLUCModelCreationDatePropertyKey, kGLUCModelCreationTimePropertyKey],

    };
}



+ (NSString *) menuIconName {
    return nil;
}

+ (UIColor *) readingColor {
    return [UIColor blackColor];
}

+ (UIColor *) historyColor: (GLUCReading *) me forUser: (GLUCUser *) user {
    return [UIColor blackColor];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.reading = @0;
        self.notes = @"";
    }

    return self;
}

// units = 0 is always the default units for the reading
- (NSNumber *) readingInUnits:(NSInteger)units {
    return self.reading;
}

+ (NSNumber *) convertValue:(NSNumber *)aValue fromUnits:(NSInteger)fromUnits toUnits:(NSInteger)units {
    return aValue;
}

@end
