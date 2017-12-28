#import "glucosio-Swift.h"
#import "GLUCUser.h"

@interface TimelineUtil : NSObject

+ (DayTimeline *) load24hTimeline: (GLUCUser *) currentUser;

@end
