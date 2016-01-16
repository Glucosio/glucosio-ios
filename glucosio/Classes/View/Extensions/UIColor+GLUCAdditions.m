#import "UIColor+GLUCAdditions.h"

#define UIColorWithHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (GLUCAdditions)

+ (UIColor *) gluc_pink {
    return [UIColor colorWithRed:1.0f green:(4.0f/255.0f) blue:(123.0/255.0f) alpha:1.0f];
}

+ (UIColor *) gluc_purple {
    return UIColorWithHEX(0x6F4EAB);
}

+ (UIColor *) gluc_blue {
    return UIColorWithHEX(0x4B8DDB);
}

+ (UIColor *) gluc_green {
    return UIColorWithHEX(0x749756);
}

+ (UIColor *) gluc_yellow {
    return UIColorWithHEX(0xE7B85D);
}

+ (UIColor *) gluc_orange {
    return UIColorWithHEX(0xE86445);
}

@end
