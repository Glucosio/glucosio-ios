#import "GLUCLoc.h"

NSString *GLUCLoc(NSString *key)
{
    NSString *stringsTable = nil;
    NSString *preferredLocale = [[NSUserDefaults standardUserDefaults] valueForKey:kGLUCApplicationLocalePrefKey];

    if (preferredLocale) {
        stringsTable = [NSString stringWithFormat:kGLUCStringsTableTemplate, [preferredLocale lowercaseString]];
    }

    return [[NSBundle mainBundle] localizedStringForKey:(key) value:key table:stringsTable];
}

