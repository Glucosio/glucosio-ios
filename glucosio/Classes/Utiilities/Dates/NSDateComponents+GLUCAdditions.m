
#import "NSDateComponents+GLUCAdditions.h"

@implementation NSDateComponents (GLUCAdditions)

- (NSComparisonResult) gluc_components:(NSCalendarUnit)flags compare:(NSDateComponents *)components
{
    if (self == components) return NSOrderedSame;
        
    if (flags & NSCalendarUnitSecond)
    {
        if ([components second] > [self second]) return NSOrderedAscending;
        else if ([components second] < [self second]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }

    if (flags & NSCalendarUnitMinute)
    {
        if ([components minute] > [self minute]) return NSOrderedAscending;
        else if ([components minute] < [self minute]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }

    if (flags & NSCalendarUnitHour)
    {
        if ([components hour] > [self hour]) return NSOrderedAscending;
        else if ([components hour] < [self hour]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }

    if (flags & NSCalendarUnitDay)
    {
        if ([components day] > [self day]) return NSOrderedAscending;
        else if ([components day] < [self day]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }
    
    if (flags & NSCalendarUnitWeekOfYear)
    {
        if ([components weekOfYear] > [self weekOfYear]) return NSOrderedAscending;
        else if ([components weekOfYear] < [self weekOfYear]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }
        
    if (flags & NSCalendarUnitMonth)
    {
        if ([components month] > [self month]) return NSOrderedAscending;
        else if ([components month] < [self month]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }
    
    if (flags & NSCalendarUnitYear)
    {
        if ([components year] > [self year]) return NSOrderedAscending;
        else if ([components year] < [self year]) return NSOrderedDescending;
        else return NSOrderedSame;
    }
    
    if (flags & NSCalendarUnitWeekday)
    {
        if ([components weekday] > [self weekday]) return NSOrderedAscending;
        else if ([components weekday] < [self weekday]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }
    
    if (flags & NSCalendarUnitWeekdayOrdinal)
    {
        if ([components weekdayOrdinal] > [self weekdayOrdinal]) return NSOrderedAscending;
        else if ([components weekdayOrdinal] < [self weekdayOrdinal]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }
    
    if (flags & NSCalendarUnitEra)
    {
        if ([components era] > [self era]) return NSOrderedAscending;
        else if ([components era] < [self era]) return NSOrderedDescending;
        else return NSOrderedSame;        
    }
    
    return NSOrderedSame;
}

- (BOOL) gluc_components:(NSCalendarUnit)flags match:(NSDateComponents *)components
{
    if (self == components) return YES;
    
    if ((flags & NSCalendarUnitYear) && ([components year] != [self year])) return NO;
    if ((flags & NSCalendarUnitSecond) && ([components second] != [self second])) return NO;
    if ((flags & NSCalendarUnitMinute) && ([components minute] != [self minute])) return NO;
    if ((flags & NSCalendarUnitHour) && ([components hour] != [self hour])) return NO;
    if ((flags & NSCalendarUnitWeekOfYear) && ([components weekOfYear] != [self weekOfYear])) return NO;
    if ((flags & NSCalendarUnitDay) && ([components day] != [self day])) return NO;
    if ((flags & NSCalendarUnitMonth) && ([components month] != [self month])) return NO;
    if ((flags & NSCalendarUnitWeekday) && ([components weekday] != [self weekday])) return NO;
    if ((flags & NSCalendarUnitWeekdayOrdinal) && ([components weekdayOrdinal] != [self weekdayOrdinal])) return NO;
    if ((flags & NSCalendarUnitEra) && ([components era] != [self era])) return NO;
    
    return YES;
}

@end
