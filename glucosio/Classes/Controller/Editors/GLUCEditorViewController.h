#import <Foundation/Foundation.h>
#import "GLUCViewController.h"
#import "GLUCModel.h"

@interface GLUCEditorViewController : GLUCViewController

@property (assign, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic, readwrite) GLUCModel *editedObject;
@property (strong, nonatomic) NSString *editedProperty;

- (IBAction)save:(UIButton *)sender;

- (NSString *)titleForRowWithKey:(NSString *)rowKey;
- (NSArray *)rowKeysForReadingType:(Class)readingType;
@end