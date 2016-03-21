#import "GLUCLoc.h"

NSString *GLUCLoc(NSString *key)
{
    NSString *retVal = key;
    NSString *stringsTable = nil;
    NSString *preferredLocale = [[NSUserDefaults standardUserDefaults] valueForKey:kGLUCApplicationLocalePrefKey];

    if (preferredLocale) {
        stringsTable = [NSString stringWithFormat:kGLUCStringsTableTemplate, [preferredLocale lowercaseString]];
    }
    
    if (stringsTable) {
        retVal = [[NSBundle mainBundle] localizedStringForKey:(key) value:key table:stringsTable];
    } else {
        retVal = NSLocalizedString(key, @"");
        if ([retVal isEqualToString:key]) {
            NSString *pathToBase = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"];
            NSBundle *bundle = nil;
            if (!pathToBase) {
                bundle = [NSBundle mainBundle];
            } else {
                bundle = [NSBundle bundleWithPath:pathToBase];
            }
            if (bundle)
                retVal = [bundle localizedStringForKey:(key) value:key table:stringsTable];
        }
    }
    return retVal;
}

