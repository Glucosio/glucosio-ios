//
//  OverViewViewController.h
//  glucosio
//
//  Created by Eugenio Baglieri on 02/09/16.
//  Copyright © 2016 Glucosio.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts-Swift.h>
#import "GLUCViewController.h"

static NSString *const kGLUCOverviewCellIdentifier = @"OverviewCell";

@interface GLUCOverviewViewController : GLUCViewController <IChartAxisValueFormatter>

@property (nonatomic, weak) IBOutlet UISwitch *nightscoutSwitch;
@property (nonatomic, weak) IBOutlet UIImageView *nightscoutIconView;

@property (nonatomic, strong) NSTimer *refreshTimer;

@property (nonatomic, strong) NSNumber *lastReadingValue;

- (IBAction)toggleNightscoutMonitoring:(UISwitch *)sender;

@end
