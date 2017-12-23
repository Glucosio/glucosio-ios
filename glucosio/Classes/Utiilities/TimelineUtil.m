#import <Realm/RLMResults.h>
#import "TimelineUtil.h"
#import "glucosio-Swift.h"
#import "GLUCBloodGlucoseReading.h"
#import "GLUCUser.h"

@implementation TimelineUtil

+ (DayTimeline *) load24hTimeline: (GLUCUser *) currentUser {
    RLMResults<GLUCBloodGlucoseReading *> * today = [GLUCBloodGlucoseReading last24hReadings];
    NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:today.count];

    for(int i=0; i < today.count; i++){
        GLUCBloodGlucoseReading * gReading = today[i];
        TimelineItem * item =[[TimelineItem alloc]
                              initWithDate: gReading.creationDate
                              value: [currentUser displayValueForReading: gReading]
                              unit: [currentUser displayUnitsForBloodGlucoseReadings]
                              description: gReading.readingType];
        items[i] = item;
    }
    DayTimeline * timeline = [[DayTimeline alloc] initWithItems:[NSArray arrayWithArray: items]];

    return timeline;
}

@end
