#import "GLUCPersistenceDDL.h"


@implementation GLUCPersistenceDDL {

}


+ (NSString *)dropReadingTable {
    return @"DROP TABLE IF EXISTS reading";
}

+ (NSString *)createReadingTable {
    NSString *createTableDDL =
            [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY,%@ INTEGER,%@ INTEGER, %@ TIMESTAMP "
                                               "DEFAULT (datetime('now','localtime') ),%@ INTEGER DEFAULT 1,%@ TEXT DEFAULT NULL );",
                                       @"reading", @"reading_id", @"reading", @"reading_type", @"reading_date", @"user_id", @"notes"];
    return createTableDDL;
}

@end