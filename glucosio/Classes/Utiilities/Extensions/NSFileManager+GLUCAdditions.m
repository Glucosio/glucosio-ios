#import "NSArray+GLUCAdditions.h"
#import "NSFileManager+GLUCAdditions.h"

@implementation NSFileManager (GLUCAdditions)

// Use home dir if doc path doesn't exist
- (NSString *)gluc_documentPath {
    NSString *destPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if (paths.count > 0) {
        destPath = [paths gluc_safeObjectAtIndex:0];

        BOOL isDir = NO;
        BOOL exists = [self fileExistsAtPath: destPath isDirectory: &isDir];
        if (!exists || !isDir) {
            destPath = NSHomeDirectory();
        }
    } else {
        destPath = NSHomeDirectory();
    }
    
    return destPath;
}

- (NSString *) gluc_documentPathForFileWithName:(NSString *)name andExtension:(NSString *)extension
{
	NSString *fullPath = nil;
    NSString *destDocPath = [self gluc_documentPath];
    if (name && name.length && destDocPath && destDocPath.length) {
        NSString *filename = [self gluc_filenameWithName:name andExtension:extension];
		fullPath = [destDocPath stringByAppendingPathComponent: filename] ;
	}
	
	return fullPath;
}

- (NSString *) gluc_filenameWithName:(NSString *)name andExtension:(NSString *)extension
{
	NSString * retVal = nil;
    
    if (name) {
        if ( (!extension) || (extension.length > 0) ) {
            retVal =  name;
        } else {
            retVal = [NSString stringWithFormat:@"%@.%@", name, extension ];
        }
    }
    
	return retVal;
}



@end
