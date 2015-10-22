
#import <Foundation/Foundation.h>

@interface NSDateComponents (GLUCAdditions)

- (NSComparisonResult) gluc_components:(NSCalendarUnit)flags compare:(NSDateComponents *)components;
- (BOOL) gluc_components:(NSCalendarUnit)flags match:(NSDateComponents *)components;

@end
