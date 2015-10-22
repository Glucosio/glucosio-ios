#import <UIKit/UIKit.h>
#import "GLUCPersistenceController.h"

@interface GLUCTabBarController : UITabBarController

@property (nonatomic, readwrite, strong) GLUCPersistenceController *model;

@end
