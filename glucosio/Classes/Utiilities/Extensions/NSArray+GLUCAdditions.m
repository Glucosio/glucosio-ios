
#import "GLUCLoc.h"
#import "NSArray+GLUCAdditions.h"

@implementation NSArray (GLUCAdditions)

- (id) gluc_safeObjectAtIndex:(NSUInteger)index
{
    id retVal = nil;
    
    if (index < self.count) {
        retVal = self[index];
    } else {
        NSLog(@"%@", GLUCLoc(@"Prevented a range exception in array element access"));
    }
    
    return retVal;
}

@end
