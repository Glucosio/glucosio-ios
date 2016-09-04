//
//  OverViewViewController.m
//  glucosio
//
//  Created by Eugenio Baglieri on 02/09/16.
//  Copyright © 2016 Glucosio.org. All rights reserved.
//

#import "OverViewViewController.h"
#import "UIColor+GLUCAdditions.h"
#import "NSCalendar+GLUCAdditions.h"
#import "NSDate+GLUCAdditions.h"
#import "GLUCAppearanceController.h"
#import "GLUCAppDelegate.h"
#import "GraphDataGenerator.h"

// import readings
#import "GLUCBloodGlucoseReading.h"
#import "GLUCHB1ACReading.h"
#import "GLUCCholesterolReading.h"
#import "GLUCBloodPressureReading.h"
#import "GLUCKetonesReading.h"
#import "GLUCBodyWeightReading.h"
#import "GLUCInsulinIntakeReading.h"

@interface OverViewViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *chartScopeControl;

@property (weak, nonatomic) IBOutlet LineChartView *chartView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak,  nonatomic) IBOutlet UIPickerView *graphPicker;

@property (strong, nonatomic) NSArray *graphPickerClasses;

@property (assign, nonatomic) Class readingTypeToGraph;

@property (strong, nonatomic) NSDictionary *colorForReadingType;


- (IBAction) updateChartScope:(id)sender;

@end

@implementation OverViewViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureView];
    
    if (!self.model) {
        self.model = [(GLUCAppDelegate *) [[UIApplication sharedApplication] delegate] appModel];
    }
    
    self.colorForReadingType = @{
                                 NSStringFromClass(GLUCBloodGlucoseReading.class) : [UIColor glucosio_fab_glucose],
                                 NSStringFromClass(GLUCHB1ACReading.class) : [UIColor glucosio_fab_HB1AC],
                                 NSStringFromClass(GLUCCholesterolReading.class) : [UIColor glucosio_fab_cholesterol],
                                 NSStringFromClass(GLUCBloodPressureReading.class) : [UIColor glucosio_fab_pressure],
                                 NSStringFromClass(GLUCKetonesReading.class) : [UIColor glucosio_fab_ketonest],
                                 NSStringFromClass(GLUCBodyWeightReading.class) : [UIColor glucosio_fab_weight],
                                 NSStringFromClass(GLUCInsulinIntakeReading.class) : [UIColor glucosio_fab_cholesterol],
                                 };
    
    self.graphPickerClasses = self.model.currentUser.readingTypes;
    
    self.readingTypeToGraph = GLUCBloodGlucoseReading.class;
    
    [self showReadingsOfType:self.readingTypeToGraph];
}

- (void)configureView {

    self.title = GLUCLoc(@"tab_overview");
    
    // Localize chart scope control
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_day") forSegmentAtIndex:0];
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_week") forSegmentAtIndex:1];
    [self.chartScopeControl setTitle:GLUCLoc(@"fragment_overview_selector_month") forSegmentAtIndex:2];
    
    //ye[self.chartView.animator animateWithXAxisDuration:0.75f yAxisDuration:0.35f];
    self.chartView.drawGridBackgroundEnabled = NO;
    self.chartView.drawBordersEnabled = NO;
    self.chartView.backgroundColor = [UIColor whiteColor];
    self.chartView.autoScaleMinMaxEnabled = NO;
    self.chartView.descriptionText = @"";
    self.chartView.pinchZoomEnabled = YES;
    self.chartView.legend.enabled = NO;
    [[self.chartView getAxis:AxisDependencyLeft] setStartAtZeroEnabled:NO];
    [[self.chartView getAxis:AxisDependencyLeft] setDrawGridLinesEnabled:NO];
    [[self.chartView getAxis:AxisDependencyRight] setStartAtZeroEnabled:NO];
    [[self.chartView getAxis:AxisDependencyRight] setEnabled:NO];
    [self.chartView.xAxis setLabelPosition:XAxisLabelPositionBottom];
    [self.chartView.xAxis setDrawGridLinesEnabled:NO];
}

#pragma mark - Actions

- (void) updateChartScope:(id)sender {
    [self showReadingsOfType:self.readingTypeToGraph];
}

#pragma mark - Private methods

- (LineChartDataSet *)lineChartDataSetWithYValues:(NSArray<ChartDataEntry *> *)yVals lineColor:(UIColor *) lineColor {
    
    LineChartDataSet *lineDataSet = [[LineChartDataSet alloc] initWithYVals:yVals];
    
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
    lineDataSet.drawCubicEnabled = YES;
    
    return lineDataSet;
}

- (void)showReadingsOfType:(Class)readingType {
    
    GraphDataGenerator *generator = [[GraphDataGenerator alloc] initWithModeController:self.model];
    
    NSArray *points = nil;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
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
    
    NSMutableArray *yVals = [NSMutableArray array];
    NSMutableArray *xVals = [NSMutableArray array];
    
    [points enumerateObjectsUsingBlock:^(GraphPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:obj.y xIndex:idx]];
        [xVals addObject:[df stringFromDate:obj.x]];
    }];
    
    LineChartDataSet *lineDataSet = [self lineChartDataSetWithYValues:yVals lineColor:self.colorForReadingType[NSStringFromClass(readingType)]];
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSet:lineDataSet];
    
    [self.chartView clear];
    self.chartView.data = data;
    [self.chartView setVisibleXRangeMinimum:10];
    [self.chartView setVisibleXRangeMaximum:20];
    [self.chartView moveViewToX:data.xValCount];
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
    Class class = [self.graphPickerClasses objectAtIndex:row];
    return NSStringFromClass(class);
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.readingTypeToGraph = [self.graphPickerClasses objectAtIndex:row];
    [self showReadingsOfType:self.readingTypeToGraph];
}


@end
