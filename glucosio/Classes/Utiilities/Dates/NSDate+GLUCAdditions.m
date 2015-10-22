
#import "NSDate+GLUCAdditions.h"
#import "NSCalendar+GLUCAdditions.h"
#import "NSDateComponents+GLUCAdditions.h"

@implementation NSDate (GLUCAdditions)


- (NSComparisonResult) gluc_compare:(NSDate *)date mask:(NSUInteger)mask
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *selfComponents = [currentCalendar components:mask fromDate:self];
    NSDateComponents *dateComponents = [currentCalendar components:mask fromDate:date];
    
    return [selfComponents gluc_components:mask compare:dateComponents];
}

- (BOOL) gluc_isEqualToDate:(NSDate *)date mask:(NSUInteger)mask
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];

    NSDateComponents *selfComponents = [currentCalendar components:mask fromDate:self];
    NSDateComponents *dateComponents = [currentCalendar components:mask fromDate:date];
    
    return [selfComponents gluc_components:mask match:dateComponents];
}

- (NSComparisonResult) gluc_compareDay:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear);
    return [self gluc_compare:date mask:mask];
}

- (BOOL) gluc_isEqualToDayOfDate:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear);
    return [self gluc_isEqualToDate:date mask:mask];
}

- (NSComparisonResult) gluc_compareWeek:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitWeekOfYear|NSCalendarUnitYear);
    return [self gluc_compare:date mask:mask];
}

- (BOOL) gluc_isEqualToWeekOfDate:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitWeekOfYear|NSCalendarUnitYear);
    return [self gluc_isEqualToDate:date mask:mask];
}

- (NSComparisonResult) gluc_compareMonth:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitMonth|NSCalendarUnitYear);
    return [self gluc_compare:date mask:mask];
}

- (BOOL) gluc_isEqualToMonthOfDate:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitMonth|NSCalendarUnitYear);
    return [self gluc_isEqualToDate:date mask:mask];
}

- (NSComparisonResult) gluc_compareDayWeekMonth:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitWeekOfYear);
    return [self gluc_compare:date mask:mask];
}

- (BOOL) gluc_isEqualToDayWeekMonthOfDate:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitWeekOfYear);
    return [self gluc_isEqualToDate:date mask:mask];
}

- (NSComparisonResult) gluc_compareYearAndMonth:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitMonth|NSCalendarUnitYear);
    return [self gluc_isEqualToDate:date mask:mask];
}

- (BOOL) gluc_isEqualToYearAndMonthOfDate:(NSDate *)date
{
    NSCalendarUnit mask = (NSCalendarUnitMonth|NSCalendarUnitYear);
    return [self gluc_isEqualToDate:date mask:mask];
}

- (NSInteger) gluc_differenceInMinutes:(NSDate *)date
{
    return ([self timeIntervalSinceDate:date] / 60);
}

- (BOOL) gluc_isBefore:(NSDate *)aDate
{
    BOOL retVal = ([self timeIntervalSince1970] < [aDate timeIntervalSince1970]);
    return retVal;
}

- (BOOL) gluc_isOnOrBefore:(NSDate *)aDate
{
    return ([self timeIntervalSince1970] <= [aDate timeIntervalSince1970]);
}

- (BOOL) gluc_isAfter:(NSDate *)aDate
{
    BOOL retVal = ([self timeIntervalSince1970] > [aDate timeIntervalSince1970]);
    return retVal;
}

- (BOOL) gluc_isOnOrAfter:(NSDate *)aDate
{
    return ([self timeIntervalSince1970] >= [aDate timeIntervalSince1970]);
}

- (unsigned long long) gluc_dateAsBCDISO
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned long long retVal = ([calendar gluc_yearFromDate:self] * 100000000LL) +
        ([calendar gluc_monthFromDate:self] * 1000000LL) + ([calendar gluc_dayFromDate:self] * 10000LL) +
        ([calendar gluc_hourFromDate:self] * 100LL) + [calendar gluc_minuteFromDate:self];
    
    return retVal;
}

+ (NSDate *) gluc_dateForRFC2445String:(NSString *)aString
{
    NSDate *retVal = nil;
    
    int year = 0;
    int month  = 0;
    int day = 0;
    int hour = 0;
    int minute = 0;
    int seconds = 0;
    
    if (aString && aString.length)
    {
        NSArray *dateComponents = [aString componentsSeparatedByString:@"T"];
        
        if (dateComponents && dateComponents.count > 0)
        {
            NSString *datePart = dateComponents[0];
            
            if (datePart && datePart.length == 8)
            {
                year = [[datePart substringWithRange:NSMakeRange(0, 4)] intValue];
                month  = [[datePart substringWithRange:NSMakeRange(4, 2)] intValue];
                day = [[datePart substringWithRange:NSMakeRange(6, 2)] intValue];
                
                //Make Sure we at least have a numeric date value
                if (year && month && day)
                {
                    if ([dateComponents count] == 2)
                    {
                        NSString *timePart = dateComponents[1];
                        
                        if (timePart && ((timePart.length == 7) || (timePart.length == 6)))
                        {
                            hour = [[timePart substringWithRange:NSMakeRange(0, 2)] intValue];
                            minute = [[timePart substringWithRange:NSMakeRange(2, 2)] intValue];
                            seconds = [[timePart substringWithRange:NSMakeRange(4, 2)] intValue];
                        }
                    }
                    
                    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
                    
                    if (dateComps)
                    {
                        dateComps.day = day;
                        dateComps.month = month;
                        dateComps.year = year;
                        dateComps.hour = hour;
                        dateComps.minute = minute;
                        dateComps.second = seconds;
                        NSCalendar *cal = [NSCalendar currentCalendar];
                        
                        if (cal)
                            retVal = [cal dateFromComponents:dateComps];
                    }
                }
            }
        }
    }
    return retVal;
}

// Careful, this only does 'Z' for Zulu time, no timezone support yet

- (NSString *) gluc_RFC2445String
{
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |
    NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:unitFlags fromDate: self];
    
    NSString *resultString = [NSString stringWithFormat:@"%ld%02ld%02ldT%02ld%02ld%02ldZ",
                              (long)dateComps.year,
                              (long)dateComps.month,
                              (long)dateComps.day,
                              (long)dateComps.hour,
                              (long)dateComps.minute,
                              (long)dateComps.second];
    
    return resultString;
}

- (NSString *) gluc_RFC2445StringForAllDay
{
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:unitFlags fromDate: self]; 
    
    NSString *resultString = [NSString stringWithFormat:@"%ld%02ld%02ld",
                              (long)dateComps.year,
                              (long)dateComps.month,
                              (long)dateComps.day];
    
    return resultString;
}


@end
