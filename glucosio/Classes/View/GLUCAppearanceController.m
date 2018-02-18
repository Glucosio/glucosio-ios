
#import "GLUCAppearanceController.h"
#import "UIColor+GLUCAdditions.h"
#import "GLUCTabBarController.h"
#import "GLUCEditorViewController.h"
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
    
    [[UINavigationBar appearance] setTranslucent:NO];

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
//    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[GLUCEditorViewController class]]] setFont:[self valueEditorTextFieldFont]];

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [self defaultFont]                                                           
                                                           } forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTitleTextAttributes:@{
                                                                                                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                                      NSFontAttributeName: [self defaultFont]
                                                                                                                      } forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [SVProgressHUD setBackgroundColor:[UIColor glucosio_pink]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

+ (UIBarButtonItem *) backButtonItemWithTarget:(id)target action:(SEL)action {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    
    [backButton.widthAnchor constraintEqualToConstant:35].active = YES;
    [backButton.heightAnchor constraintEqualToConstant:35].active = YES;
    [backButton setImage:[UIImage imageNamed:@"ButtonIconBack"] forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

+ (UIFont *) valueEditorTextFieldFont {
    return [self defaultFontOfSize:64.0f];
}

+ (UIImage *) menuIconForReadingType:(Class)readingType {
    UIImage *retVal = nil;
    
    if ([readingType isSubclassOfClass:[GLUCReading class]]) {
        UIImage *menuIcon = [UIImage imageNamed:[readingType menuIconName]];
        if (menuIcon) {
            UIImageView *menuIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f,32.0f)];
            menuIconView.contentMode = UIViewContentModeScaleAspectFit;
            menuIconView.backgroundColor = [readingType readingColor];
            menuIconView.layer.cornerRadius = 4.0f;
            menuIconView.image = menuIcon;
            UIGraphicsBeginImageContext(CGSizeMake(32.0f,32.0f));
            [menuIconView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
            retVal = [finalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIGraphicsEndImageContext();
        }

    }
    return retVal;
}


@end
