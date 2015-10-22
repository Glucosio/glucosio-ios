
#import <UIKit/UIKit.h>

@interface NSFileManager (GLUCAdditions)

- (NSString *) gluc_documentPath;
- (NSString *) gluc_documentPathForFileWithName:(NSString *)filename andExtension:(NSString *)extension;
- (NSString *) gluc_filenameWithName:(NSString *)filename andExtension:(NSString *)extension;

@end
