//
//  OverViewViewController.m
//  glucosio
//
//  Created by Eugenio Baglieri on 02/09/16.
//  Copyright © 2016 Glucosio.org. All rights reserved.
//

#import "GLUCOverviewViewController.h"
#import "UIColor+GLUCAdditions.h"
#import "NSCalendar+GLUCAdditions.h"
#import "NSDate+GLUCAdditions.h"
#import "GLUCAppearanceController.h"
#import "GLUCAppDelegate.h"
#import "GLUCGraphDataGenerator.h"

// import readings
#import "GLUCBloodGlucoseReading.h"
#import "GLUCHbA1cReading.h"
#import "GLUCCholesterolReading.h"
#import "GLUCBloodPressureReading.h"
#import "GLUCKetonesReading.h"
#import "GLUCBodyWeightReading.h"
#import "GLUCInsulinIntakeReading.h"

// services
#import "GLUCDataServiceNightscout.h"

@interface GLUCOverviewViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *chartScopeControl;

@property (weak, nonatomic) IBOutlet LineChartView *chartView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak,  nonatomic) IBOutlet UIPickerView *graphPicker;

@property (strong, nonatomic) NSArray *graphPickerClasses;

@property (assign, nonatomic) Class readingTypeToGraph;

@property (strong, nonatomic) NSDictionary *colorForReadingType;

@property(strong, nonatomic) NSArray *rowTitles;

@property(strong, nonatomic) NSArray *rowValues;

@property(strong, nonatomic) UITextView *tipView;

@property(strong, nonatomic) NSMutableArray *yVals;

@property(strong, nonatomic) NSMutableArray *xVals;

@property(strong, nonatomic) NSDateFormatter *chartDateFormatter;

- (IBAction) updateChartScope:(id)sender;

@end

@implementation GLUCOverviewViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureView];
    
    self.rowTitles = @[GLUCLoc(@"fragment_overview_last_reading"), GLUCLoc(@"HbA1c:")];
    
    // TODO: too specific to blood glucose readings.  For now the overview controller only shows glucose,
    // but at some point other readings will probably need to be displayed.
    
    NSString *lastReading = [NSString stringWithFormat:@"%@ %@",
                             [self.model.currentUser bloodGlucoseReadingValueInPreferredUnits:[self.model lastBloodGlucoseReading]],
                             [self.model.currentUser displayValueForKey:kGLUCUserPreferredBloodGlucoseUnitsPropertyKey]];;
    
    self.lastReadingValue = @0;
    
    self.rowValues = @[lastReading, @"fragment_overview_trend_positive"];
    
    self.title = GLUCLoc(@"tab_overview");
    
    self.colorForReadingType = @{
                                 NSStringFromClass(GLUCBloodGlucoseReading.class) : [UIColor glucosio_fab_glucose],
                                 NSStringFromClass(GLUCHbA1cReading.class) : [UIColor glucosio_fab_HbA1c],
                                 NSStringFromClass(GLUCCholesterolReading.class) : [UIColor glucosio_fab_cholesterol],
                                 NSStringFromClass(GLUCBloodPressureReading.class) : [UIColor glucosio_fab_pressure],
                                 NSStringFromClass(GLUCKetonesReading.class) : [UIColor glucosio_fab_ketonest],
                                 NSStringFromClass(GLUCBodyWeightReading.class) : [UIColor glucosio_fab_weight],
                                 NSStringFromClass(GLUCInsulinIntakeReading.class) : [UIColor glucosio_fab_cholesterol],
                                 };
    
    self.graphPickerClasses = self.model.currentUser.readingTypes;
    
    self.readingTypeToGraph = GLUCBloodGlucoseReading.class;
    
    self.xVals = [NSMutableArray array];
    self.yVals = [NSMutableArray array];
    self.chartDateFormatter = [[NSDateFormatter alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    

    [self.model configureServices];

    BOOL disableNightscout = YES;
    GLUCDataServiceNightscout *nightscoutService = [GLUCDataServiceNightscout objectForPrimaryKey:@"Nightscout"];
    
    if (nightscoutService) {
        disableNightscout = ![nightscoutService.serviceEnabled boolValue];
    }
    
    self.nightscoutSwitch.hidden = disableNightscout;
    self.nightscoutIconView.hidden = disableNightscout;
    self.nightscoutLabel.hidden = disableNightscout;
    
    self.speechEnabled = !disableNightscout;

    
}

- (void) startTimer {
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.toValue = @0;
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.toValue = @2;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[fade,pulse];
    group.duration = 1.0;
    group.repeatCount = MAXFLOAT;
    group.autoreverses = YES;
    [self.nightscoutIconView.layer addAnimation:group forKey:@"nightscoutworking"];
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.model refreshFromServices];
        [self showReadingsOfType:self.readingTypeToGraph];
    }];
}

- (void) stopTimer {
    [self.nightscoutIconView.layer removeAllAnimations];
    
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

- (IBAction)toggleNightscoutMonitoring:(UISwitch *)sender {
    
    if ([sender isOn]) {
        if ([self.model nightscoutAvailable]) {
            [self startTimer];
        } else {
            [sender setOn:NO];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:GLUCLoc(@"Missing Configuration")
                                          message:GLUCLoc(@"Please configure Nightscout first in the settings->data section")
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:GLUCLoc(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    } else {
        [self stopTimer];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleServiceAlarmNotification:)
                                                 name:@"ServiceAlarm" object:nil];
    
    [self showReadingsOfType:self.readingTypeToGraph];
    
    if ([self.nightscoutSwitch isOn])
        [self startTimer];
}

- (void)configureView {

    self.title = GLUCLoc(@"tab_overview");
    
    // Localize chart scope control
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_day") forSegmentAtIndex:0];
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_week") forSegmentAtIndex:1];
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_month") forSegmentAtIndex:2];
    
    self.chartView.drawGridBackgroundEnabled = NO;
    self.chartView.drawBordersEnabled = NO;
    self.chartView.backgroundColor = [UIColor whiteColor];
    self.chartView.autoScaleMinMaxEnabled = NO;
    self.chartView.chartDescription = nil;
    self.chartView.pinchZoomEnabled = YES;
    self.chartView.legend.enabled = NO;
    
    [[self.chartView getAxis:AxisDependencyLeft] setDrawGridLinesEnabled:NO];
    [[self.chartView getAxis:AxisDependencyRight] setEnabled:NO];
    [self.chartView.xAxis setLabelPosition:XAxisLabelPositionBottom];
    [self.chartView.xAxis setDrawGridLinesEnabled:NO];
}

#pragma mark - Accessors

- (UITextView *)tipView {
    if (_tipView == nil) {
        _tipView = [[UITextView alloc] init];
        _tipView.textColor = [UIColor darkGrayColor];
        _tipView.font = [GLUCAppearanceController defaultFont];
        _tipView.text = [NSString stringWithFormat:@"%@: %@", GLUCLoc(@"tab_tips"), GLUCLoc(@"tip_example")];
        _tipView.layer.borderColor = [[UIColor glucosio_pink] CGColor];
        _tipView.layer.borderWidth = 0.25f;
        _tipView.layer.cornerRadius = 8.0f;
        [_tipView sizeToFit];
        _tipView.editable = false;
    }
    
    return _tipView;
}

#pragma mark - Actions

- (void) updateChartScope:(id)sender {
    [self showReadingsOfType:self.readingTypeToGraph];
}

- (void) refreshFromExternalServices {
    [self.model performSelector:@selector(refreshFromServices) withObject:nil afterDelay:5.0];
}
#pragma mark - Private methods

- (LineChartDataSet *)lineChartDataSetWithYValues:(NSArray<ChartDataEntry *> *)yVals lineColor:(UIColor *) lineColor {
    
    LineChartDataSet *lineDataSet = [[LineChartDataSet alloc] initWithValues:yVals];
    
    lineDataSet.colors = @[lineColor];
    lineDataSet.circleColors = @[lineColor];
    lineDataSet.lineWidth = 2.0f;
    lineDataSet.circleRadius = 4.0f;
    lineDataSet.drawCircleHoleEnabled = YES;
    lineDataSet.circleHoleRadius = 2.0f;
    lineDataSet.drawFilledEnabled = YES;
    lineDataSet.fillColor = lineColor;
    lineDataSet.fillAlpha = 0.15f;
    lineDataSet.drawValuesEnabled = NO;
    lineDataSet.highlightColor = [UIColor glucosio_gray_light];
    lineDataSet.cubicIntensity = 0.2f;
    
    return lineDataSet;
}

- (void)showLastReadingOfType:(Class)readingType {
    GLUCReading *reading = [self.model lastReadingOfType:readingType];
    NSString *valueStr = @"";
    NSString *lastReading = GLUCLoc(@"fragment_empty_text");
    
    if (reading) {
        NSNumber *displayVal = [reading readingInUnits:[self.model.currentUser unitPreferenceForReadingType:readingType]];

        NSString *floatString = [displayVal stringValue];
        NSArray *floatStringComps = [floatString componentsSeparatedByString:@"."];
        NSUInteger numberOfDecimalPlaces = 0;
        if (floatStringComps && floatStringComps.count > 1) {
            NSString *decimalPart = [floatStringComps objectAtIndex:1];
            if (decimalPart)
                numberOfDecimalPlaces = decimalPart.length;
        }
        
        valueStr = [self.model.currentUser displayValueForReading:reading];
        if (numberOfDecimalPlaces > 0) {
            floatString = valueStr;
        }

        lastReading = [NSString stringWithFormat:@"%@ %@", valueStr,
                       [self.model.currentUser displayUnitsForReading:reading]];
        
        if (![self.lastReadingValue isEqualToNumber:reading.reading]) {
            if (self.speechEnabled) {
                [self say:floatString];
            }
        }
        self.lastReadingValue = reading.reading;
        
    }
    
    self.rowValues = @[lastReading, [self hb1acAverageValue]];
    
    [self.tableView reloadData];
    
}

- (NSString *) stringForValue:(double)value axis:(ChartAxisBase *)axis {
    NSString *retVal = @"";
    int xIndex = (int)value;
    
    if (xIndex >= 0 && xIndex < self.xVals.count) {
        retVal = [self.xVals objectAtIndex:xIndex];
    }
    return retVal;
}

- (void)showReadingsOfType:(Class)readingType {
    
    GLUCGraphDataGenerator *generator = [[GLUCGraphDataGenerator alloc] initWithModeController:self.model];
    
    NSArray *points = nil;
    NSDateFormatter *df = self.chartDateFormatter;
    
    switch (self.chartScopeControl.selectedSegmentIndex) {
        case 0: // Daily
            [df setDateStyle:NSDateFormatterShortStyle];
            [df setTimeStyle:NSDateFormatterNoStyle];
            points = [generator graphPointsForReadingType:readingType];
            break;
        case 1: // Weekly
            [df setDateFormat:@"ww-yyyy"];
            points = [generator weeklyAverageGraphPointsForReadingType:readingType];
            break;
        case 2: // Monthly
            [df setDateFormat:@"MM-yyyy"];
            points = [generator montlyAverageGraphPointsForReadingType:readingType];
            break;
        default:
            break;
    }
 
    [self.yVals removeAllObjects];
    [self.xVals removeAllObjects];
    
    if (points && points.count > 0) {
        
        
        [points enumerateObjectsUsingBlock:^(GLUCGraphPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ChartDataEntry *entryYValue = [[ChartDataEntry alloc] initWithX:idx y:obj.y];
            NSString *entryXValue = [df stringFromDate:obj.x];
            
            
            if (entryXValue && entryYValue) {
                [self.yVals addObject:entryYValue];
                [self.xVals addObject:entryXValue];
            }
        }];
        
        if ([self.yVals count] && [self.xVals count]) {
            UIColor *colorForReadingType = [readingType readingColor];
            LineChartDataSet *lineDataSet = [self lineChartDataSetWithYValues:self.yVals lineColor:colorForReadingType ?: [UIColor blackColor]];
            LineChartData *data = [[LineChartData alloc] initWithDataSet:lineDataSet];
            
            [self.chartView clear];
            [self.chartView.leftAxis removeAllLimitLines];

            self.chartView.data = data;
            [self.chartView setVisibleXRangeMinimum:10];
            [self.chartView setVisibleXRangeMaximum:20];
            // ACF replaced data.xvalCount with data.entryCount
            [self.chartView resetViewPortOffsets];
            [self.chartView moveViewToX:data.entryCount];
            
            self.chartView.leftAxis.enabled = YES;
            self.chartView.xAxis.enabled = YES;
            
            ChartXAxis *xAxis = self.chartView.xAxis;
            //xAxis.drawLimitLinesBehindDataEnabled = YES;
            xAxis.granularityEnabled = YES;
            xAxis.granularity = 1;
            xAxis.valueFormatter = self;
            xAxis.labelRotationAngle = -45.0f;
            
            if (readingType == [GLUCBloodGlucoseReading class]) {
                GLUCUser *user = self.model.currentUser;
                
                ChartLimitLine *maxLimit = [[ChartLimitLine alloc] initWithLimit:user.rangeMax.doubleValue label:GLUCLoc(@"reading_high")];
                maxLimit.lineColor = [UIColor glucosio_reading_high];
                maxLimit.lineWidth = 0.8f;
                
                ChartLimitLine *minLimit = [[ChartLimitLine alloc] initWithLimit:user.rangeMin.doubleValue label:GLUCLoc(@"reading_low")];
                minLimit.lineColor = [UIColor glucosio_reading_low];
                minLimit.lineWidth = 0.8f;
                
                ChartYAxis *leftAxis = self.chartView.leftAxis;
                [leftAxis addLimitLine:maxLimit];
                [leftAxis addLimitLine:minLimit];
                leftAxis.drawLimitLinesBehindDataEnabled = YES;
                
                
            }
            
        } else {
            self.chartView.leftAxis.enabled = NO;
            self.chartView.xAxis.enabled = NO;
            self.chartView.data = nil;
        }
        
        
    } else {
        self.chartView.xAxis.enabled = NO;
        self.chartView.leftAxis.enabled = NO;
        self.chartView.data = nil;
    }
    
    [self showLastReadingOfType:readingType];
    
    self.chartView.noDataText = @"There are not enough measurements for the chart.";
    [self.chartView notifyDataSetChanged];
}

- (NSString *)hb1acAverageValue {
    return [[self.model currentUser] hb1acAverageValue];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return  self.graphPickerClasses.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *retVal = @"???";
    Class class = [self.graphPickerClasses objectAtIndex:row];
    if (class && [class isSubclassOfClass:[GLUCReading class]]) {
        retVal = [class title];
    } else {
        retVal = NSStringFromClass(class);
    }
    return retVal;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.readingTypeToGraph = [self.graphPickerClasses objectAtIndex:row];
    [self showReadingsOfType:self.readingTypeToGraph];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rowTitles.count;
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
    
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.font = [GLUCAppearanceController defaultBoldFont];
            break;
        case 1:
            cell.detailTextLabel.textColor = [UIColor glucosio_reading_ok];
            cell.detailTextLabel.font = [GLUCAppearanceController defaultFont];
            cell.detailTextLabel.numberOfLines = 0;
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UIPickerViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGSize size = [self.tipView sizeThatFits:CGSizeMake(self.tableView.frame.size.width, FLT_MAX)];
    return size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.tipView;
}


@end
