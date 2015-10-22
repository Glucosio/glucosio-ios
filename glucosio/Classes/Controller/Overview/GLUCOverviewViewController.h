#import <UIKit/UIKit.h>
#import <Charts/Charts-Swift.h>
#import "GLUCViewController.h"

static NSString *const kGLUCOverviewCellIdentifier = @"OverviewCell";

@interface GLUCOverviewViewController : GLUCViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *chartScopeControl;
@property (strong, nonatomic) IBOutlet LineChartView *chartView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction) updateChartScope:(id)sender;

@end
