
#import <UIKit/UIKit.h>


static NSString *const kGLUCAppearanceDefaultFontName = @"Lato-Regular";
static NSString *const kGlUCAppearanceDefaultBoldFontName = @"Lato-Bold";

@interface GLUCAppearanceController : NSObject

+ (void) setAppearanceDefaults;

+ (UIFont *) valueEditorTextFieldFont;
+ (UIFont *) defaultFontOfSize:(CGFloat)fontSize;
+ (UIFont *) defaultBoldFontOfSize:(CGFloat)fontSize;
+ (UIFont *) defaultFont;
+ (UIFont *) defaultBoldFont;

+ (UIImage *) menuIconForReadingType:(Class)readingType;
+ (UIBarButtonItem *) backButtonItemWithTarget:(id)target action:(SEL)action;

@end
