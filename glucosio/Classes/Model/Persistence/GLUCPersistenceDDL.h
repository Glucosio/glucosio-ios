#import <Foundation/Foundation.h>

@interface GLUCPersistenceDDL : NSObject

+ (NSString *) createReadingTableNamed:(NSString *)tableName;
+ (NSString *) createBloodGlucoseReadingTableNamed:(NSString *) readingTableName;
+ (NSString *) dropReadingTableNamed:(NSString *) readingTableName;

@end