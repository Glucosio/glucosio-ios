
#import "GLUCAppearanceController.h"
#import "UIColor+GLUCAdditions.h"
#import "GLUCTabBarController.h"
#import "SVProgressHUD.h"

@implementation GLUCAppearanceController {

}

+ (UIFont *) defaultFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kGLUCAppearanceDefaultFontName size:fontSize];

}

+ (UIFont *) defaultBoldFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kGlUCAppearanceDefaultBoldFontName size:fontSize];
}

+ (UIFont *) defaultFont {
    return [self defaultFontOfSize:[UIFont systemFontSize]];
}

+ (UIFont *) defaultBoldFont {
    return [self defaultBoldFontOfSize:[UIFont systemFontSize]];
}

+ (void) setAppearanceDefaults {
    [[UINavigationBar appearance] setBarTintColor:[UIColor glucosio_pink]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITableViewCell appearance] setTintColor:[UIColor glucosio_pink]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [self defaultFont]
    }];

    [[UIButton appearance] setTintColor:[UIColor glucosio_pink]];

    [[UILabel appearance] setFont:[self defaultFont]];
    [[UITextField appearance] setFont:[self defaultFont]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIButton class]]] setFont:[self defaultFont]];
    [[UITabBar appearance] setBarTintColor:[UIColor glucosio_pink]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UITabBar class]]] setTintColor:[UIColor yellowColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName: [UIColor yellowColor],
                                                        NSFontAttributeName: [self defaultFont]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName: [UIColor whiteColor],
                                                        NSFontAttributeName: [self defaultFont]
                                                        } forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTintColor:[UIColor glucosio_pink]];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              NSFontAttributeName: [self defaultFont]
                                                              } forState:UIControlStateNormal];
    
    [[UITableView appearance] setBackgroundColor:[UIColor whiteColor]];

    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITextField class]]] setFont:[self valueEditorTextFieldFont]];

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [self defaultFont]                                                           
                                                           } forState:UIControlStateNormal];
    
    [SVProgressHUD setBackgroundColor:[UIColor glucosio_pink]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

+ (UIFont *) valueEditorTextFieldFont {
    return [self defaultFontOfSize:64.0f];
}




@end