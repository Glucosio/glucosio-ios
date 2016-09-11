#import "GLUCReadingEditorViewController.h"
#import "GLUCAppDelegate.h"
#import <Realm/RLMRealm.h>
#import "GLUCListEditorViewController.h"
#import "GLUCEditorViewController.h"
#import "GLUCLoc.h"

@implementation GLUCEditorViewController {

}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self.saveButton setTitle:GLUCLoc([self.saveButton titleForState:UIControlStateNormal]) forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem.title = GLUCLoc(@"dialog_add_cancel");
}


- (IBAction) save:(UIButton *)sender {
    [self.model saveAll];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *) titleForRowWithKey:(NSString *)rowKey {
    NSString *retVal = rowKey;
    NSDictionary *schema = [self.editedObject.class schema];
    if (schema) {
        retVal = GLUCLoc(schema[kGLUCModelSchemaPropertiesKey][rowKey][kGLUCModelAttributeTitleKey]);
    }

    return retVal;
}

- (NSArray *)rowKeysForReadingType:(Class)readingType {
    NSMutableArray *retVal = nil;
    NSDictionary *schema = [readingType schema];
    if (schema) {
        retVal = schema[kGLUCModelEditorRowsPropertiesKey];
    }
    return retVal;
}
@end