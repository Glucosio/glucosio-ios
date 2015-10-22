
#import <Foundation/Foundation.h>


@interface NSDate (GLUCAdditions)

- (NSComparisonResult) gluc_compareDay:(NSDate *)date;
- (BOOL) gluc_isEqualToDayOfDate:(NSDate *)date;

- (NSComparisonResult) gluc_compareWeek:(NSDate *)date;
- (BOOL) gluc_isEqualToWeekOfDate:(NSDate *)date;

- (NSComparisonResult) gluc_compareMonth:(NSDate *)date;
- (BOOL) gluc_isEqualToMonthOfDate:(NSDate *)date;

- (NSComparisonResult) gluc_compareDayWeekMonth:(NSDate *)date;
- (BOOL) gluc_isEqualToDayWeekMonthOfDate:(NSDate *)date;

- (NSComparisonResult) gluc_compareYearAndMonth:(NSDate *)date;
- (BOOL) gluc_isEqualToYearAndMonthOfDate:(NSDate *)date;

- (NSInteger) gluc_differenceInMinutes:(NSDate *)date;

- (BOOL) gluc_isBefore:(NSDate *)aDate;
- (BOOL) gluc_isOnOrBefore:(NSDate *)aDate;
- (BOOL) gluc_isAfter:(NSDate *)aDate;
- (BOOL) gluc_isOnOrAfter:(NSDate *)aDate;

- (unsigned long long) gluc_dateAsBCDISO;

+ (NSDate *) gluc_dateForRFC2445String:(NSString *)aString;
- (NSString *) gluc_RFC2445String;
- (NSString *) gluc_RFC2445StringForAllDay;

@end
