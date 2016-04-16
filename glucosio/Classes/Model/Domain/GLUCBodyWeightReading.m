//
// Created by Chris Walters on 4/10/16.
// Copyright (c) 2016 Glucosio.org. All rights reserved.
//

#import "GLUCBodyWeightReading.h"


@implementation GLUCBodyWeightReading {

}

+ (NSString *) entityName {
    return @"body_weight_reading";
}

+ (NSString *)title {
    return GLUCLoc(@"Body Weight");
}

- (void)setupDefaultData {
    self.schema = @{
            kGLUCModelSettingsPropertiesKey : @[kGLUCReadingModelValuePropertyKey,
                    kGLUCModelCreationDateKey],

            kGLUCModelSchemaPropertiesKey : @{
                    kGLUCReadingModelValuePropertyKey : @{
                            kGLUCModelAttributeKey : kGLUCReadingModelValuePropertyKey,
                            kGLUCModelAttributeTitleKey : @"dialog_add_concentration",
                            kGLUCModelAttributeTypeKey : @"NSNumber",
                    },
            }
    };

}

- (instancetype) init {
    if ((self = [super init]) != nil) {
        [self setupDefaultData];
    }
    return self;
}
@end