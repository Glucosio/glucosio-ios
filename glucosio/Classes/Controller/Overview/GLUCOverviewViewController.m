#import "GLUCOverviewViewController.h"
#import "UIColor+GLUCAdditions.h"
#import "NSCalendar+GLUCAdditions.h"
#import "NSDate+GLUCAdditions.h"
#import "GLUCAppearanceController.h"
#import "GLUCAppDelegate.h"

@interface GLUCOverviewViewController ()
@property (strong, nonatomic) NSArray *rowTitles;
@property (strong, nonatomic) NSArray *rowValues;
@property (strong, nonatomic) UITextView *tipView;
@end

@implementation GLUCOverviewViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    
    if (!self.model) {
        self.model = [(GLUCAppDelegate *)[[UIApplication sharedApplication] delegate] appModel];
    }

    self.rowTitles = @[GLUCLoc(@"fragment_overview_last_reading"), GLUCLoc(@"fragment_overview_trend")];

    NSString *lastReading = [NSString stringWithFormat:@"%@ %@",
                    [self.model.currentUser bloodGlucoseReadingValueInPreferredUnits:[self.model lastBloodGlucoseReading]],
                    [self.model.currentUser displayValueForKey:kGLUCUserPreferredBloodGlucoseUnitsPropertyKey]];;
    
    self.rowValues = @[lastReading, @"fragment_overview_trend_positive"];
    
    self.title = GLUCLoc(@"tab_overview");
    
    // Localize chart scope control
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_day") forSegmentAtIndex:0];
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_week") forSegmentAtIndex:1];
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_month") forSegmentAtIndex:2];
    
    self.tipView = [[UITextView alloc] init];
    self.tipView.textColor = [UIColor darkGrayColor];
    self.tipView.font = [GLUCAppearanceController defaultFont];
    self.tipView.text = [NSString stringWithFormat:@"%@: %@", GLUCLoc(@"tab_tips"), GLUCLoc(@"tip_example")];
    self.tipView.layer.borderColor = [[UIColor glucosio_pink] CGColor];
    self.tipView.layer.borderWidth = 0.25f;
    self.tipView.layer.cornerRadius = 8.0f;
    [self.tipView sizeToFit];
    self.tipView.editable = false;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    GLUCBloodGlucoseReading *reading = [self.model lastBloodGlucoseReading];
    NSString *valueStr = @"";
    NSString *lastReading = GLUCLoc(@"fragment_empty_text");

    if (reading) {
        if (self.model.currentUser.needsBloodGlucoseReadingUnitConversion) {
            valueStr = [self.numberFormatter stringFromNumber:[self.model.currentUser bloodGlucoseReadingValueInPreferredUnits:reading]];
        }
        else {
            valueStr = [NSString stringWithFormat:@"%@",
                            [self.model.currentUser bloodGlucoseReadingValueInPreferredUnits:reading]];
        }

        lastReading = [NSString stringWithFormat:@"%@ %@", valueStr,
                        [self.model.currentUser displayValueForKey:kGLUCUserPreferredBloodGlucoseUnitsPropertyKey]];;

    }


    self.rowValues = @[lastReading, GLUCLoc(@"TODO: In range and healthy")]; // TODO: compute actual range

    [self.tableView reloadData];
}

- (void) configureStandardDataSet:(LineChartDataSet *)dataSet {
    //    dataSet.label = @""; // GLUCLoc(@"fragment_overview_selector_day");
    //     set1.setColor(getResources().getColor(R.color.glucosio_pink));
    dataSet.colors = @[[UIColor glucosio_pink]];
    //     set1.setLineWidth(2f);
    dataSet.lineWidth = 2.0f;
    //     set1.setCircleColor(getResources().getColor(R.color.glucosio_pink));
    dataSet.circleColors = @[[UIColor glucosio_pink]];
    //     set1.setCircleSize(4f);
    dataSet.circleRadius = 4.0f;
    //     set1.setDrawCircleHole(true);
    dataSet.drawCircleHoleEnabled = YES;
    //     set1.disableDashedLine();
    // ???
    //     set1.setFillAlpha(255);
    dataSet.fillAlpha = 0.15f;
    //     set1.setDrawFilled(true);
    dataSet.drawFilledEnabled = YES;
    //     set1.setValueTextSize(0);
    //     set1.setValueTextColor(Color.parseColor("#FFFFFF"));
    dataSet.drawValuesEnabled = NO;
    //     set1.setFillDrawable(getResources().getDrawable(R.drawable.graph_gradient));
    dataSet.fillColor = [UIColor glucosio_pink]; // ???
    //     set1.setHighLightColor(getResources().getColor(R.color.glucosio_gray_light));
    dataSet.highlightColor = [UIColor lightGrayColor];
    //     set1.setCubicIntensity(0.2f);
    dataSet.cubicIntensity = 0.2f;
    //     set1.setDrawCubic(true);
    dataSet.drawCubicEnabled = NO;
    //    dataSet.drawValuesEnabled = NO;
    //    dataSet.fillColor = [UIColor glucosio_pink];

}
- (void) displayStandardChart:(ChartData *)data {
    [self.chartView.animator animateWithXAxisDuration:0.75f yAxisDuration:0.35f];
    self.chartView.drawGridBackgroundEnabled = NO;
    self.chartView.drawBordersEnabled = NO;
    self.chartView.backgroundColor = [UIColor whiteColor];
    self.chartView.autoScaleMinMaxEnabled = YES;
    self.chartView.descriptionText = @"";
    self.chartView.legend.enabled = NO;
    [[self.chartView getAxis:AxisDependencyLeft] setStartAtZeroEnabled:NO];
    [[self.chartView getAxis:AxisDependencyLeft] setDrawGridLinesEnabled:NO];
    [[self.chartView getAxis:AxisDependencyRight] setStartAtZeroEnabled:NO];
    [[self.chartView getAxis:AxisDependencyRight] setEnabled:NO];
    [self.chartView.xAxis setLabelPosition:XAxisLabelPositionBottom];
    [self.chartView.xAxis setDrawGridLinesEnabled:NO];
    self.chartView.data = data;
}

- (void) chartDaily {
    NSDate *startOfMonth = [[NSCalendar currentCalendar] gluc_firstDayOfMonthForDate:[NSDate date]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSMutableDictionary *buckets = [NSMutableDictionary dictionary];
    NSArray *allReadings = [self.model allBloodGlucoseReadings:YES];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    for (GLUCBloodGlucoseReading *reading in allReadings) {
        if ([reading.creationDate gluc_isOnOrAfter:startOfMonth]) {
            NSInteger day = [[NSCalendar currentCalendar] gluc_dayFromDate:reading.creationDate];
            NSInteger month = [[NSCalendar currentCalendar] gluc_monthFromDate:reading.creationDate];
            NSInteger year = [[NSCalendar currentCalendar] gluc_yearFromDate:reading.creationDate];
            NSString *dayKey = [NSString stringWithFormat:@"%04ld (%02ld/%02ld)", (long)year, (long)month, (long)day];
            NSMutableArray *averageForWeek = [buckets valueForKey:dayKey];
            if (!averageForWeek) {
                averageForWeek = [NSMutableArray array];
                [buckets setValue:averageForWeek forKey:dayKey];
            }
            [averageForWeek addObject:[self.model.currentUser bloodGlucoseReadingValueInPreferredUnits:reading]];
            
        }
    }

    NSMutableArray *yVals = [NSMutableArray array];
    
    NSArray *bucketKeys = [buckets.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    if (buckets && buckets.allKeys.count) {
        int i = 0;
        for (NSString *bucketKey in bucketKeys) {
            NSNumber *bucketAvg = [[buckets valueForKey:bucketKey] valueForKeyPath:@"@avg.intValue"];
            [buckets setValue:bucketAvg forKey:bucketKey];
            [yVals addObject:[[ChartDataEntry alloc] initWithValue:[bucketAvg doubleValue] xIndex:i++ data:nil]];
        }
    }
    
    self.chartView.noDataText = GLUCLoc(@"fragment_empty_text");
    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithYVals:yVals];
    
    [self configureStandardDataSet:dataSet];

    LineChartData *data = [[LineChartData alloc] initWithXVals:bucketKeys dataSet:dataSet];
    
    [self displayStandardChart:data];
}

- (void) chartWeeklyAverage {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSMutableDictionary *buckets = [NSMutableDictionary dictionary];
    NSArray *allReadings = [self.model allBloodGlucoseReadings:YES];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];

    for (GLUCBloodGlucoseReading *reading in allReadings) {
        NSInteger week = [[NSCalendar currentCalendar] gluc_weekFromDate:reading.creationDate];
        NSInteger month = [[NSCalendar currentCalendar] gluc_monthFromDate:reading.creationDate];
        NSInteger year = [[NSCalendar currentCalendar] gluc_yearFromDate:reading.creationDate];
        if (week == 1 && month == 12) {
            ++year; // sometimes, last week of the year has a end date which is in the next year
        }
        NSDate *startOfWeek = [[NSCalendar currentCalendar] gluc_startOfWeekInYear:week inYear:year];
        NSString *weekKey = [startOfWeek gluc_RFC2445String];

        NSMutableArray *averageForWeek = [buckets valueForKey:weekKey];
        if (!averageForWeek) {
            averageForWeek = [NSMutableArray array];
            [buckets setValue:averageForWeek forKey:weekKey];
        }
        [averageForWeek addObject:[self.model.currentUser bloodGlucoseReadingValueInPreferredUnits:reading]];
    }
    
    NSMutableArray *yVals = [NSMutableArray array];

    NSArray *bucketKeys = [buckets.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *bucketKeyLabels = [NSMutableArray arrayWithCapacity:bucketKeys.count];
    
    if (buckets && buckets.allKeys.count) {
        int i = 0;
        for (NSString *bucketKey in bucketKeys) {
            NSDate *bucketKeyDate = [NSDate gluc_dateForRFC2445String:bucketKey];
            NSNumber *bucketAvg = [[buckets valueForKey:bucketKey] valueForKeyPath:@"@avg.intValue"];
            [bucketKeyLabels addObject:[NSDateFormatter localizedStringFromDate:bucketKeyDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]];
            [buckets setValue:bucketAvg forKey:bucketKey];
            [yVals addObject:[[ChartDataEntry alloc] initWithValue:[bucketAvg doubleValue] xIndex:i++ data:nil]];
        }
    }

    self.chartView.noDataText = GLUCLoc(@"fragment_empty_text");

    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithYVals:yVals];
    [self configureStandardDataSet:dataSet];
    LineChartData *data = [[LineChartData alloc] initWithXVals:bucketKeyLabels dataSet:dataSet];
    [self displayStandardChart:data];
}

- (void) chartMonthlyAverage {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSMutableDictionary *buckets = [NSMutableDictionary dictionary];
    NSArray *allReadings = [self.model allBloodGlucoseReadings:YES];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    for (GLUCBloodGlucoseReading *reading in allReadings) {
        NSInteger month = [[NSCalendar currentCalendar] gluc_monthFromDate:reading.creationDate];
        NSInteger year = [[NSCalendar currentCalendar] gluc_yearFromDate:reading.creationDate];
        NSDate *startOfMonth = [[NSCalendar currentCalendar] gluc_startOfMonth:month inYear:year];
        NSString *monthKey = [startOfMonth gluc_RFC2445String];

        NSMutableArray *averageForMonth = [buckets valueForKey:monthKey];
        if (!averageForMonth) {
            averageForMonth = [NSMutableArray array];
            [buckets setValue:averageForMonth forKey:monthKey];
        }
        [averageForMonth addObject:[self.model.currentUser bloodGlucoseReadingValueInPreferredUnits:reading]];
    }
    
    NSMutableArray *yVals = [NSMutableArray array];
    
    NSArray *bucketKeys = [buckets.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *bucketKeyLabels = [NSMutableArray arrayWithCapacity:bucketKeys.count];

    if (buckets && buckets.allKeys.count) {
        int i = 0;
        for (NSString *bucketKey in bucketKeys) {
            NSDate *bucketKeyDate = [NSDate gluc_dateForRFC2445String:bucketKey];
            NSNumber *bucketAvg = [[buckets valueForKey:bucketKey] valueForKeyPath:@"@avg.intValue"];
            [bucketKeyLabels addObject:[NSDateFormatter localizedStringFromDate:bucketKeyDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]];
            [buckets setValue:bucketAvg forKey:bucketKey];
            [yVals addObject:[[ChartDataEntry alloc] initWithValue:[bucketAvg doubleValue] xIndex:i++ data:nil]];
        }
    }
    
    self.chartView.noDataText = GLUCLoc(@"fragment_empty_text");
    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithYVals:yVals];
    [self configureStandardDataSet:dataSet];
    LineChartData *data = [[LineChartData alloc] initWithXVals:bucketKeyLabels dataSet:dataSet];
    [self displayStandardChart:data];

}

- (void) updateChart {
    switch ([self.chartScopeControl selectedSegmentIndex]) {
        case 0:
        default:
            [self chartDaily];
            break;
        case 1:
            [self chartWeeklyAverage];
            break;
        case 2:
            [self chartMonthlyAverage];
            break;
    }
}

- (IBAction) updateChartScope:(id)sender {
    [self updateChart];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateChart];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowTitles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kGLUCOverviewCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGLUCOverviewCellIdentifier];
    }
    
    cell.textLabel.text = self.rowTitles[indexPath.row];
    cell.detailTextLabel.text = self.rowValues[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [GLUCAppearanceController defaultFont];

    switch(indexPath.row) {
        case 0:
            cell.detailTextLabel.font = [GLUCAppearanceController defaultBoldFont];
            break;
        case 1:
            cell.detailTextLabel.textColor = [UIColor glucosio_reading_ok];
            cell.detailTextLabel.font = [GLUCAppearanceController defaultFont];
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGSize size = [self.tipView sizeThatFits:CGSizeMake(self.tableView.frame.size.width, FLT_MAX)];
    return size.height;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.tipView;
}


@end
