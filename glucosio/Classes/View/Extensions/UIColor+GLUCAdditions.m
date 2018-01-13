#import "UIColor+GLUCAdditions.h"

#define UIColorWithHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]


@implementation UIColor (GLUCAdditions)

//    <color name="glucosio_pink">#E84579</color>
+ (UIColor *)glucosio_pink {
    return UIColorWithHEX(0xE84579);
}

//    <color name="glucosio_pink_light">#ec6a93</color>
+ (UIColor *)glucosio_pink_light {
    return UIColorWithHEX(0xec6a93);
}

//    <color name="glucoso_pink_graph_2">#99FCE2EA</color>
+ (UIColor *)glucosio_pink_graph_2 {
    return UIColorWithHEX(0x99FCE2EA);
}

//    <color name="glucoso_pink_graph_1">#80FCE2EA</color>
+ (UIColor *)glucosio_pink_graph_1 {
    return UIColorWithHEX(0x80FCE2EA);
}

//    <color name="glucoso_pink_a1c_converter">#e95374</color>
+ (UIColor *)glucosio_pink_a1c_converter {
    return UIColorWithHEX(0xe95374);
}

//    <color name="glucoso_pink_dark">#C23965</color>
+ (UIColor *)glucosio_pink_dark {
    return UIColorWithHEX(0xC23965);
}

//    <color name="glucoso_accent">#F0D04C</color>
+ (UIColor *)glucosio_accent {
    return UIColorWithHEX(0xF0D04C);
}

//    <color name="glucoso_fab_glucose">#E84579</color>
+ (UIColor *)glucosio_fab_glucose {
    return UIColorWithHEX(0xE84579);
}

+ (UIColor *)glucosio_fab_insulin {
    return UIColorWithHEX(0xE53299);
}

//    <color name="glucoso_fab_HbA1c">#E86445</color>
+ (UIColor *)glucosio_fab_HbA1c {
    return UIColorWithHEX(0xE86445);
}

//    <color name="glucoso_fab_cholesterol">#E7B85D</color>
+ (UIColor *)glucosio_fab_cholesterol {
    return UIColorWithHEX(0xE7B85D);
}

//    <color name="glucoso_fab_pressure">#749756</color>
+ (UIColor *)glucosio_fab_pressure {
    return UIColorWithHEX(0x749756);
}

//    <color name="glucoso_fab_ketonest">#4B8DDB</color>
+ (UIColor *)glucosio_fab_ketonest {
    return UIColorWithHEX(0x4B8DDB);
}

//    <color name="glucoso_fab_weight">#6F4EAB</color>
+ (UIColor *)glucosio_fab_weight {
    return UIColorWithHEX(0x6F4EAB);
}

//    <color name="glucoso_separator">#eaeaea</color>
+ (UIColor *)glucosio_separator {
    return UIColorWithHEX(0xeaeaea);
}

//    <color name="glucoso_gray_light">#D1D1D1</color>
+ (UIColor *)glucosio_gray_light {
    return UIColorWithHEX(0xD1D1D1);
}

//    <color name="glucoso_text">#323232</color>
+ (UIColor *)glucosio_text {
    return UIColorWithHEX(0x323232);
}

//    <color name="glucoso_text_dark">#000000</color>
+ (UIColor *)glucosio_text_dark {
    return UIColorWithHEX(0x000000);
}

//    <color name="glucoso_text_light">#686E71</color>
+ (UIColor *)glucosio_text_light {
    return UIColorWithHEX(0x686E71);
}

//    <color name="glucoso_text_green">#46a644</color>
+ (UIColor *)glucosio_text_green {
    return UIColorWithHEX(0x46a644);
}

//    <color name="glucoso_text_red">#e04737</color>
+ (UIColor *)glucosio_text_red {
    return UIColorWithHEX(0xe04737);
}

//    <color name="glucoso_light_grey_background">#F9F9F9</color>
+ (UIColor *)glucosio_light_grey_background {
    return UIColorWithHEX(0xF9F9F9);
}

//    <color name="mdtp_acent_color">@color/glucosio_pink</color>
+ (UIColor *)mdtp_accent_color {
    return [UIColor glucosio_pink];
}

//    <color name="mdtp_acent_color_dark">@color/glucosio_pink_dark</color>
+ (UIColor *)mdtp_accent_color_dark {
    return [UIColor glucosio_pink_dark];
}

//    <color name="glucoso_reading_ok">#749756</color>
+ (UIColor *)glucosio_reading_ok {
    return UIColorWithHEX(0x749756);
}

//    <color name="glucoso_reading_hyper">#E86445</color>
+ (UIColor *)glucosio_reading_hyper {
    return UIColorWithHEX(0xE86445);
}

//    <color name="glucoso_reading_low">#4B8DDB</color>
+ (UIColor *)glucosio_reading_low {
    return UIColorWithHEX(0x4B8DDB);
}

//    <color name="glucoso_reading_high">#E7B85D</color>
+ (UIColor *)glucosio_reading_high {
    return UIColorWithHEX(0xE7B85D);
}

//    <color name="glucoso_reading_hypo">#6F4EAB</color>
+ (UIColor *)glucosio_reading_hypo {
    return UIColorWithHEX(0x6F4EAB);
}

//
//    <color name="Smoochaccent">@color/glucosio_pink</color>
+ (UIColor *)smooch_accent {
    return [UIColor glucosio_pink];
}

//    <color name="SmoochaccentDark">@color/glucosio_pink_dark</color>
+ (UIColor *)smooch_accentDark {
    return [UIColor glucosio_pink_dark];
}

//    <color name="SmoochaccentLight">@color/glucosio_pink_light</color>
+ (UIColor *)smooch_accentLight {
    return [UIColor glucosio_pink_light];
}


@end
