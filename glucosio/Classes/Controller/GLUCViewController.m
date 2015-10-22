#import "GLUCViewController.h"


@implementation GLUCViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.positiveFormat = @"0.0";
    self.numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
}


- (UIBarButtonItem *) cancelButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:GLUCLoc(@"Cancel") style:UIBarButtonItemStylePlain target:nil action:nil];
}
@end