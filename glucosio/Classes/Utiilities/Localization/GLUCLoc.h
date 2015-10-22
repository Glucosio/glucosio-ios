#import <Foundation/Foundation.h>

#ifndef GLUC_LOC_STR_H
#define GLUC_LOC_STR_H

static NSString *const kGLUCApplicationLocalePrefKey = @"GLUCApplicationLocale";
static NSString *const kGLUCStringsTableTemplate = @"GLUCStrings_%@";

NSString *GLUCLoc(NSString *key);

#endif
