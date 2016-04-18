#import <UIKit/UIKit.h>
#import "GLUCViewController.h"

static NSString *const kGLUCHistoryCellIdentifier = @"HistoryCell";

@interface GLUCHistoryViewController : GLUCViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readwrite) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) NSArray *readings;
@property (strong, nonatomic) Class readingClass;

@end
