#import "GLUCListEditorViewController.h"
#import "GLUCEditorViewController.h"
#import "GLUCLoc.h"

@implementation GLUCEditorViewController {

}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self.saveButton setTitle:GLUCLoc([self.saveButton titleForState:UIControlStateNormal]) forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem.title = GLUCLoc(@"Cancel");
}


- (IBAction) save:(UIButton *)sender {
    [self.model saveAll];
    [self.navigationController popViewControllerAnimated:YES];
}

@end