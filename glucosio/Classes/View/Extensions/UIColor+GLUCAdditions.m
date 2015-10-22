#import "UIColor+GLUCAdditions.h"

@implementation UIColor (GLUCAdditions)

+ (UIColor *) gluc_pink {
    return [UIColor colorWithRed:1.0f green:(4.0f/255.0f) blue:(123.0/255.0f) alpha:1.0f];
}

+ (UIColor *) gluc_green {
    return [UIColor colorWithRed:70.0f/255.0f green:166.0f/255.0f blue:0.0f alpha:1.0f];
}

@end
