#import <Foundation/Foundation.h>

@interface GLUCPersistenceDDL : NSObject

+ (NSString *) createReadingTableNamed:(NSString *)tableName;
+ (NSString *) dropReadingTable:(NSString *)tableName;

@end