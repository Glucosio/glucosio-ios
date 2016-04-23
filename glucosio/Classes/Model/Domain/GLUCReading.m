//
// Created by Chris Walters on 4/10/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import <Realm/Realm.h>
#import "GLUCReading.h"


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
- (instancetype)init {
    self = [super init];
    if (self) {
        self.reading = @0;
        self.notes = @"";
    }

    return self;
}


@end