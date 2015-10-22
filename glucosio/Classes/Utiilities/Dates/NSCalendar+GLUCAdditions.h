
#import <Foundation/Foundation.h>

@interface NSCalendar (GLUCAdditions)

- (NSInteger) gluc_secondFromDate:(NSDate *)date;
- (NSInteger) gluc_minuteFromDate:(NSDate *)date;
- (NSInteger) gluc_hourFromDate:(NSDate *)date;
- (NSInteger) gluc_dayFromDate:(NSDate *)date;
- (NSInteger) gluc_dayOfYearFromDate:(NSDate *)date;
- (NSInteger) gluc_weekFromDate:(NSDate *)date;
- (NSInteger) gluc_weekdayFromDate:(NSDate *)date;
- (NSInteger) gluc_monthFromDate:(NSDate *)date;
- (NSInteger) gluc_yearFromDate:(NSDate *)date;
- (NSDateComponents *) gluc_standardComponentsForDate:(NSDate *)aDate;

- (NSDate *) gluc_dateByRoundingUpDate:(NSDate *)date;

- (NSDate *) gluc_dateByAddingSeconds:(NSInteger)seconds toDate:(NSDate *)date;
- (NSDate *) gluc_dateByAddingMinutes:(NSInteger)minutes toDate:(NSDate *)date;
- (NSDate *) gluc_dateByAddingHours:(NSInteger)hours toDate:(NSDate *)date;
- (NSDate *) gluc_dateByAddingDays:(NSInteger)days toDate:(NSDate *)date;
- (NSDate *) gluc_dateByAddingWeeks:(NSInteger)weeks toDate:(NSDate *)date;
- (NSDate *) gluc_dateByAddingMonths:(NSInteger)months toDate:(NSDate *)date;
- (NSDate *) gluc_dateByAddingYears:(NSInteger)years toDate:(NSDate *)date;

- (NSDate *) gluc_dateForWeekday:(int)weekdayIndex withOrdinal:(int)ordinal withDate:(NSDate *)aDate;

- (NSArray *) gluc_datesWithValues:(NSArray *)values
                      forUnit:(unsigned)componentUnit 
                      forDate:(NSDate *)aDate 
              minAllowedValue:(int)minAllowedValue 
              maxAllowedValue:(int)maxAllowedValue;

- (NSArray *) gluc_datesWithSeconds:(NSArray *)seconds forDate:(NSDate *)aDate;
- (NSArray *) gluc_datesWithMinutes:(NSArray *)seconds forDate:(NSDate *)aDate;
- (NSArray *) gluc_datesWithHours:(NSArray *)seconds forDate:(NSDate *)aDate;

- (NSDate *) gluc_startOfWeekInYear:(NSInteger)weekOfYear inYear:(NSInteger)year;
- (NSDate *) gluc_startOfMonth:(NSInteger)monthOfYear inYear:(NSInteger)year;

- (NSDate *) gluc_firstMinuteOfDayForDate:(NSDate *)date;
- (NSDate *) gluc_lastMinuteOfDayForDate:(NSDate *)date;
- (NSDate *) gluc_firstDayOfMonthForDate:(NSDate *)date;
- (NSDate *) gluc_lastDayOfMonthForDate:(NSDate *)date;
- (NSDate *) gluc_firstDayOfYearForDate:(NSDate *)date;
- (NSDate *) gluc_lastDayOfYearForDate:(NSDate *)date;
- (BOOL) gluc_dateIsInLeapYear:(NSDate *)date;

- (NSDate *) gluc_defaultStartDateForDate:(NSDate *)date;

- (float) gluc_roundedUpPercentageOfEntireDayForDate:(NSDate *)aDate;
- (float) gluc_percentageOfEntireDayForDate:(NSDate *)aDate;

@end
