
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GLUCPersistenceController.h"

static NSString *const kGLUCEulaViewControllerIdentifier = @"EULAView";
static NSString *const kGLUCListEditorViewControllerIdentifier = @"ListEditor";
static NSString *const kGLUCIndexedListEditorViewControllerIdentifier = @"IndexedListEditor";
static NSString *const kGLUCReadingEditorViewControllerIdentifier = @"ReadingEditor";
static NSString *const kGLUCValueEditorViewControllerIdentifier = @"ValueEditor";
static NSString *const kGLUCAboutViewControllerIdentifier = @"AboutView";
static NSString *const kGLUCPrivacyViewControllerIdentifier = @"PrivacyView";
static NSString *const kGLUCNightscoutSettingsViewControllerIdentifier = @"NightscoutSettingsView";

static NSString *const kGLUCMainStoryboardIdentifier = @"Main";
static NSString *const kGLUCSettingsStoryboardIdentifier = @"Settings";
static NSString *const kGLUCNotesEditorViewControllerIdentifier = @"NotesEditor";

@interface GLUCViewController : UIViewController
@property (nonatomic, readwrite, strong) GLUCPersistenceController *model;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@property (nonatomic, assign) BOOL speechEnabled;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynth;

- (UIBarButtonItem *) cancelButtonItem;

- (void) say:(NSString *)aString;


@end

@protocol GLUCViewControllerRecordCreation

- (IBAction)add:(id)sender;

@end;
