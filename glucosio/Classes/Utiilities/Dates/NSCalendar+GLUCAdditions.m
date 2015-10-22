
#import "NSDate+GLUCAdditions.h"
#import "NSCalendar+GLUCAdditions.h"

@implementation NSCalendar (GLUCAdditions)

#pragma mark Components from Date

- (NSInteger) gluc_secondFromDate:(NSDate *)date
{
    return [[self components:NSCalendarUnitSecond fromDate:date] second];
}

- (NSInteger) gluc_minuteFromDate:(NSDate *)date
{
    return [[self components:NSCalendarUnitMinute fromDate:date] minute];
}

- (NSInteger) gluc_hourFromDate:(NSDate *)date
{
    return [[self components:NSCalendarUnitHour fromDate:date] hour];
}

- (NSInteger) gluc_dayOfYearFromDate:(NSDate *)date
{
    return [self ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
}

- (NSInteger) gluc_dayFromDate:(NSDate *)date
{
    return [[self components:NSCalendarUnitDay fromDate:date] day];
}

- (NSInteger) gluc_weekFromDate:(NSDate *)date
{
    return [[self components:NSCalendarUnitWeekOfYear fromDate:date] weekOfYear];
}

- (NSInteger) gluc_weekdayFromDate:(NSDate *)date
{
    return [[self components:NSCalendarUnitWeekday fromDate:date] weekday];
}

- (NSInteger) gluc_monthFromDate:(NSDate *)date
{
    return [[self components:NSCalendarUnitMonth fromDate:date] month];
}

- (NSInteger) gluc_yearFromDate:(NSDate *)date
{
    return [[self components:NSCalendarUnitYear fromDate:date] year];
}

- (NSDateComponents *) gluc_standardComponentsForDate:(NSDate *)aDate
{
    NSDateComponents *retVal = nil;
    if (aDate)
    {
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
            NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;
        
        retVal = [self components:unitFlags fromDate:aDate];
    }
    
    return retVal;
}

#pragma mark Rounding

- (NSDate *) gluc_dateByRoundingUpDate:(NSDate *)date;
{
    NSDateComponents *components = [self gluc_standardComponentsForDate:date];
    
    double percentageOfHour = components.minute / 60.0;
    
    if (percentageOfHour > 0)
    {
        if (percentageOfHour <= 0.25)
            components.minute = 15;
        else if (percentageOfHour > 0.25 && percentageOfHour <= 0.5)
            components.minute = 30;
        else if (percentageOfHour > 0.5 && percentageOfHour <= 0.75)
            components.minute = 45;
        else
        {
            components = [self gluc_standardComponentsForDate:[self gluc_dateByAddingHours:1 toDate:date]];
            components.minute = 0;
        }
    } else
        components.minute = 0;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

#pragma mark Date by Adding Components

- (NSDate *) gluc_dateByAddingSeconds:(NSInteger)seconds toDate:(NSDate *)date;
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:seconds];
    NSDate *incrementedDate = [self dateByAddingComponents:components toDate:date options:0];
    return incrementedDate;
}

- (NSDate *) gluc_dateByAddingMinutes:(NSInteger)minutes toDate:(NSDate *)date;
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];
    NSDate *incrementedDate = [self dateByAddingComponents:components toDate:date options:0];
    return incrementedDate;
}

- (NSDate *) gluc_dateByAddingHours:(NSInteger)hours toDate:(NSDate *)date;
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hours];
    NSDate *incrementedDate = [self dateByAddingComponents:components toDate:date options:0];
    return incrementedDate;
}

- (NSDate *) gluc_dateByAddingDays:(NSInteger)days toDate:(NSDate *)date;
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    NSDate *incrementedDate = [self dateByAddingComponents:components toDate:date options:0];
    return incrementedDate;
}

- (NSDate *) gluc_dateByAddingWeeks:(NSInteger)weeks toDate:(NSDate *)date;
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    NSDate *incrementedDate = [self dateByAddingComponents:components toDate:date options:0];
    return incrementedDate;
}

- (NSDate *) gluc_dateByAddingMonths:(NSInteger)months toDate:(NSDate *)date;
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    NSDate *incrementedDate = [self dateByAddingComponents:components toDate:date options:0];
    return incrementedDate;
}

- (NSDate *) gluc_dateByAddingYears:(NSInteger)years toDate:(NSDate *)date;
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    NSDate *incrementedDate = [self dateByAddingComponents:components toDate:date options:0];
    return incrementedDate;
}

- (NSDate *) gluc_dateForWeekday:(int)weekdayIndex withOrdinal:(int)ordinal withDate:(NSDate *)aDate {
    NSDate *retVal = nil;
    
    NSDateComponents *components = [self gluc_standardComponentsForDate:aDate];
    
    if (components)
    {
        [components setWeekday:weekdayIndex];
        [components setWeekdayOrdinal:ordinal];
        
        retVal = [self dateFromComponents:components];
        
    }
    
    return retVal;
}

- (NSArray *) gluc_datesWithValues:(NSArray *)values
                      forUnit:(unsigned)componentUnit 
                      forDate:(NSDate *)aDate 
              minAllowedValue:(int)minAllowedValue 
              maxAllowedValue:(int)maxAllowedValue
{
    
    NSArray *retVal = nil;
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    
    for (NSNumber *valueAsNumber in values)
    {
        NSDateComponents *comps = [self gluc_standardComponentsForDate:aDate];
        int valueAsInt = [valueAsNumber intValue];
        
        if (valueAsInt >= minAllowedValue && valueAsInt <= maxAllowedValue)
        {
            if (comps)
            {
                switch (componentUnit)
                {
                    case NSCalendarUnitSecond:
                        comps.second = valueAsInt;
                        break;
                    case NSCalendarUnitMinute:
                        comps.minute = valueAsInt;
                        break;
                    case NSCalendarUnitHour:
                        comps.hour = valueAsInt;
                        break;
                    case NSCalendarUnitDay:
                        comps.day = valueAsInt;
                        break;
                    case NSCalendarUnitMonth:
                        comps.month = valueAsInt;
                        break;
                    case NSCalendarUnitYear:
                        comps.year = valueAsInt;
                        break;
                    default:
                        break;
                }
                
                [results addObject:[self dateFromComponents:comps]];
            }
        }
    }
    
    if (results && results.count)
        retVal = [NSArray arrayWithArray:results];
    
    
    return retVal;
    
    
}

- (NSArray *) gluc_datesWithSeconds:(NSArray *)seconds forDate:(NSDate *)aDate
{
    return [self gluc_datesWithValues:seconds forUnit:NSCalendarUnitSecond forDate:aDate minAllowedValue:0 maxAllowedValue:59];
}

- (NSArray *) gluc_datesWithMinutes:(NSArray *)seconds forDate:(NSDate *)aDate
{
    return [self gluc_datesWithValues:seconds forUnit:NSCalendarUnitMinute forDate:aDate minAllowedValue:0 maxAllowedValue:59];
}

- (NSArray *) gluc_datesWithHours:(NSArray *)seconds forDate:(NSDate *)aDate
{
    return [self gluc_datesWithValues:seconds forUnit:NSCalendarUnitHour forDate:aDate minAllowedValue:0 maxAllowedValue:23];
}

#pragma mark Convenience to get a reasonable start date and time

- (NSDate *) gluc_defaultStartDateForDate:(NSDate *)date
{
    NSDateComponents *todayComponents = [self gluc_standardComponentsForDate:[NSDate date]];
    NSDateComponents *comps = [self gluc_standardComponentsForDate:date];
    
    NSInteger minuteForDate = comps.minute;
    
    if (minuteForDate >= 30) 
        comps.hour = todayComponents.hour + 1;
    else
        comps.hour = todayComponents.hour;

    comps.minute = 0;
    comps.second = 0;
    
    return [self dateFromComponents:comps];
}

- (NSDate *) gluc_startOfWeekInYear:(NSInteger)weekOfYear inYear:(NSInteger)year
{
    NSDate *retVal = nil;
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    [dateComponents setYear:year];
    [dateComponents setWeekOfYear:weekOfYear];
    [dateComponents setWeekday:1];
    [dateComponents setYearForWeekOfYear:year];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];

    retVal = [self dateFromComponents:dateComponents];

    return retVal;

}

- (NSDate *) gluc_startOfMonth:(NSInteger)monthOfYear inYear:(NSInteger)year
{
    NSDate *retVal = nil;
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    [dateComponents setYear:year];
    [dateComponents setMonth:monthOfYear];
    [dateComponents setWeekOfMonth:1];
    [dateComponents setWeekday:1];
    [dateComponents setYearForWeekOfYear:year];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];

    retVal = [self dateFromComponents:dateComponents];

    return retVal;

}

- (NSDate *) gluc_firstMinuteOfDayForDate:(NSDate *)date
{
    NSDate *retVal = nil;
    NSDateComponents *lastMinute = [[NSDateComponents alloc] init];
    
    [lastMinute setYear:[self gluc_yearFromDate:date]];
    [lastMinute setMonth:[self gluc_monthFromDate:date]];
    [lastMinute setDay:[self gluc_dayFromDate:date]];
    [lastMinute setHour:0];
    [lastMinute setMinute:0];
    [lastMinute setSecond:0];
    
    retVal = [self dateFromComponents:lastMinute];
    
    return retVal;    
}

- (NSDate *) gluc_lastMinuteOfDayForDate:(NSDate *)date
{
    NSDate *retVal = nil;
    NSDateComponents *lastMinute = [[NSDateComponents alloc] init];
    
    [lastMinute setYear:[self gluc_yearFromDate:date]];
    [lastMinute setMonth:[self gluc_monthFromDate:date]];
    [lastMinute setDay:[self gluc_dayFromDate:date]];
    [lastMinute setHour:23];
    [lastMinute setMinute:59];
    [lastMinute setSecond:59];
    
    retVal = [self dateFromComponents:lastMinute];
    
    return retVal;
    
}
- (NSDate *) gluc_firstDayOfMonthForDate:(NSDate *)date;
{
    NSDate *retVal = nil;
    NSDateComponents *firstDay = [[NSDateComponents alloc] init];
    
    [firstDay setYear:[self gluc_yearFromDate:date]];
    [firstDay setMonth:[self gluc_monthFromDate:date]];
    [firstDay setDay:1];
    [firstDay setHour:[self gluc_hourFromDate:date]];
    [firstDay setMinute:[self gluc_minuteFromDate:date]];
    [firstDay setSecond:[self gluc_secondFromDate:date]];
    
    retVal = [self dateFromComponents:firstDay];

    return retVal;
}

- (float) gluc_roundedUpPercentageOfEntireDayForDate:(NSDate *)aDate
{
    NSInteger hour = [self gluc_hourFromDate:aDate];
    NSInteger minutes = [self gluc_minuteFromDate:aDate];
    
    if (minutes > 0)
        ++hour;
    
    return (hour/24.0);
}

- (float) gluc_percentageOfEntireDayForDate:(NSDate *)aDate
{
    return (([self gluc_hourFromDate:aDate] * 60) + [self gluc_minuteFromDate:aDate]) / (24.0 * 60.0);
}

- (NSDate *) gluc_lastDayOfMonthForDate:(NSDate *)date;
{
    NSDate *retVal = nil;
    NSDateComponents *lastDay = [[NSDateComponents alloc] init];
    
    [lastDay setYear:[self gluc_yearFromDate:date]];
    [lastDay setMonth:[self gluc_monthFromDate:date]];
    [lastDay setHour:[self gluc_hourFromDate:date]];
    [lastDay setMinute:[self gluc_minuteFromDate:date]];
    [lastDay setSecond:[self gluc_secondFromDate:date]];
    
    switch ([self gluc_monthFromDate:date])
    {
        case 1:
            [lastDay setDay:31];
            break;
        case 2:
            if ([self gluc_dateIsInLeapYear:date])
            {
                [lastDay setDay:29];
            }
            else
            {
                [lastDay setDay:28];
            }
            break;
        case 3:
            [lastDay setDay:31];
            break;
        case 4:
            [lastDay setDay:30];
            break;
        case 5:
            [lastDay setDay:31];
            break;
        case 6:
            [lastDay setDay:30];
            break;
        case 7:
            [lastDay setDay:31];
            break;
        case 8:
            [lastDay setDay:31];
            break;
        case 9:
            [lastDay setDay:30];
            break;
        case 10:
            [lastDay setDay:31];
            break;
        case 11:
            [lastDay setDay:30];
            break;
        case 12:
            [lastDay setDay:31];
            break;
        default: // shouldn't happen
            [lastDay setDay:31];
            break;
    }
    
    retVal = [self dateFromComponents:lastDay];
    
    return retVal;
}

- (NSDate *) gluc_firstDayOfYearForDate:(NSDate *)date;
{
    NSDate *retVal = nil;
    NSDateComponents *firstDay = [[NSDateComponents alloc] init];
    
    [firstDay setYear:[self gluc_yearFromDate:date]];
    [firstDay setMonth:1];
    [firstDay setDay:1];
    [firstDay setHour:[self gluc_hourFromDate:date]];
    [firstDay setMinute:[self gluc_minuteFromDate:date]];
    [firstDay setSecond:[self gluc_secondFromDate:date]];
    
    retVal = [self dateFromComponents:firstDay];
    
    return retVal;
}

- (NSDate *) gluc_lastDayOfYearForDate:(NSDate *)date;
{
    NSDate *retVal = nil;
    NSDateComponents *lastDay = [[NSDateComponents alloc] init];
    
    [lastDay setYear:[self gluc_yearFromDate:date]];
    [lastDay setMonth: 12];
    [lastDay setHour:[self gluc_hourFromDate:date]];
    [lastDay setMinute:[self gluc_minuteFromDate:date]];
    [lastDay setSecond:[self gluc_secondFromDate:date]];
    [lastDay setDay:31];
    
    retVal = [self dateFromComponents:lastDay];
    
    return retVal;
}

- (BOOL) gluc_dateIsInLeapYear:(NSDate *)date;
{
    NSInteger _year = [self gluc_yearFromDate:date];
    
    if (_year % 4 != 0) 
    { 
        return NO; 
    } 
    else 
    { 
        if (_year % 100 != 0) 
        { 
            return YES;
        } 
        else 
        { 
            if (_year % 400 != 0) 
            { 
                return NO; 
            } 
            else 
            { 
                return YES;    
            } 
        } 
    } 
}

- (NSDate *) gluc_firstMinuteOfDayForComponents:(NSDateComponents *)srcComps usingComponents:(NSDateComponents *)comps
{
    NSDate *retVal = nil;
    
    [comps setYear:srcComps.year];
    [comps setMonth:srcComps.month];
    [comps setDay:srcComps.day];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    retVal = [self dateFromComponents:comps];
    
    return retVal;    
}

- (NSDate *) gluc_lastMinuteOfDayForComponents:(NSDateComponents *)srcComps usingComponents:(NSDateComponents *)comps
{
    NSDate *retVal = nil;
    
    [comps setYear:srcComps.year];
    [comps setMonth:srcComps.month];
    [comps setDay:srcComps.day];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    
    retVal = [self dateFromComponents:comps];
    
    return retVal;    
}

- (NSDate *) gluc_dateByAddingDays:(NSInteger)days toDate:(NSDate *)date usingComponents:(NSDateComponents *)comps
{
    [comps setDay:days];
    NSDate *incrementedDate = [self dateByAddingComponents:comps toDate:date options:0];
    return incrementedDate;    
}


@end
