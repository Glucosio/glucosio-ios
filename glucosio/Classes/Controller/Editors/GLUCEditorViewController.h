#import <Foundation/Foundation.h>
#import "GLUCViewController.h"
#import "GLUCModel.h"

@interface GLUCEditorViewController : GLUCViewController

@property (assign, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) GLUCModel *editedObject;
@property (strong, nonatomic) NSString *editedProperty;

- (IBAction)save:(UIButton *)sender;


@end