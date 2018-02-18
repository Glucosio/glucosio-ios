#import "GLUCSettingsViewController.h"
#import "GLUCEditorViewController.h"
#import "GLUCListEditorViewController.h"
#import "GLUCIndexedListEditorViewController.h"
#import "GLUCValueEditorViewController.h"
#import "UIColor+GLUCAdditions.h"
#import "GLUCLoc.h"
#import "GLUCEULAViewController.h"
#import "GLUCAppearanceController.h"
#import "GLUCAboutViewController.h"
#import "GLUCPrivacyViewController.h"
#import "GLUCNightscoutSettingsViewController.h"

#import "GLUCAppDelegate.h"
#import "SVProgressHUD.h"

@interface GLUCSettingsViewController()
@property (strong, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) IBOutlet UIView *welcomeView;
@property (strong, nonatomic) IBOutlet UILabel *helloLabel;
@property (strong, nonatomic) IBOutlet UILabel *introLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *getStartedButtonCell;
@property (strong, nonatomic) IBOutlet UIButton *getStartedButton;
@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;
@property (nonatomic, readwrite, strong) NSMutableDictionary *settings;
@property (nonatomic, readwrite, strong) NSArray *settingKeys;
@property (nonatomic, readwrite, strong) NSArray *aboutKeys;
@property (nonatomic, readwrite, strong) NSArray *dataKeys;
@end

@implementation GLUCSettingsViewController

#define ABOUT_SECTION 2
#define DATA_SECTION 1

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.welcomeMode) {
        self.settingKeys = [self.model.currentUser requiredStartProperties];
    } else {
        self.settingKeys = [self.model.currentUser settingsProperties];
    }

    self.aboutKeys = @[GLUCLoc(@"preferences_version"), GLUCLoc(@"preferences_terms"), GLUCLoc(@"preferences_privacy")];
    self.dataKeys = @[GLUCLoc(@"preferences_data_export"), GLUCLoc(@"preferences_data_import"), GLUCLoc(@"preferences_data_nightscout_refresh")];

    self.settings = [NSMutableDictionary dictionary];

    self.settingsTableView.backgroundColor = [UIColor whiteColor];

    if (self.welcomeMode) {
        self.title = GLUCLoc(kGLUCAppNameKey);
        self.helloLabel.text = GLUCLoc(@"title_activity_hello");
        self.helloLabel.font = [GLUCAppearanceController defaultBoldFontOfSize:32.0f];
        self.introLabel.text = GLUCLoc(@"helloactivity_subhead");
    } else {
        [self.stackView removeArrangedSubview:self.welcomeView];
        self.title = GLUCLoc(@"action_settings");
    }
    
    self.getStartedButton = (UIButton *)[self.getStartedButtonCell viewWithTag:10];
    if (self.getStartedButton) {
        self.getStartedButton.enabled = NO;
        [self.getStartedButton setTitle:GLUCLoc(@"helloactivity_button_start") forState:UIControlStateNormal];
        [self.getStartedButton addTarget:self action:@selector(getStarted:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (IBAction)getStarted:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGLUCModelInitialSettingsCompletedKey];
    [self.model saveAll];
    [self gotoOverview];
}

- (BOOL) validToGetStarted {
    BOOL isValid = NO;

    NSNumber *age= [self.model.currentUser valueForKey:kGLUCUserAgePropertyKey];
    if (age) {
        isValid = [self.model.currentUser validateValue:&age forKey:kGLUCUserAgePropertyKey error:NULL];
    }
    return isValid;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.settingsTableView reloadData];
    self.getStartedButton.enabled = [self validToGetStarted];
    [super viewWillAppear:animated];
}

- (void) hintRequiredRows {
    if (![self validToGetStarted]) {
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^void() {
                             [[self.settingsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setHighlighted:YES animated:YES];
                         }
                         completion:^(BOOL finished) {
                             [[self.settingsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setHighlighted:NO animated:YES];
                         }];
    }
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    [self hintRequiredRows];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger retVal  = 6;
    switch (section) {
        case 0:
        default:
            retVal = self.settingKeys.count + (self.welcomeMode ? 1 : 0);
            break;
        case DATA_SECTION:
            retVal = self.dataKeys.count;
            break;
        case ABOUT_SECTION:
            retVal = self.aboutKeys.count;
            break;
    }
    return retVal;
}

- (void) gotoOverview {
    [(GLUCAppDelegate *)[[UIApplication sharedApplication] delegate] showOverview];
}

- (void) gotoEULAViewRequireConfirmation:(BOOL)requireConfirmation {
    self.navigationItem.backBarButtonItem = nil;
    GLUCEULAViewController *eulaViewController = (GLUCEULAViewController *) [[self storyboard] instantiateViewControllerWithIdentifier:kGLUCEulaViewControllerIdentifier];
    eulaViewController.requireConfirmation = requireConfirmation;
    [self.navigationController pushViewController:eulaViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row < self.settingKeys.count) {
                NSString *targetKey = self.settingKeys[(NSUInteger) indexPath.row];
                if ([self.model.currentUser propertyIsLookup:targetKey]) {
                    
                    if ([targetKey isEqualToString:kGLUCUserCountryPreferenceKey]) {
                        GLUCIndexedListEditorViewController *editor = (GLUCIndexedListEditorViewController *) [[self storyboard] instantiateViewControllerWithIdentifier:kGLUCIndexedListEditorViewControllerIdentifier];
                        editor.editedObject = self.model.currentUser;
                        editor.editedProperty = targetKey;
                        editor.title = [self.model.currentUser titleForKey:targetKey];
                        editor.model = self.model;
                        
                        if ([self.model.currentUser propertyIsIndirectLookup:targetKey]) {
                            NSString *currentValue = [self.model.currentUser displayValueForKey:targetKey];
                            editor.items = [[self.model.currentUser potentialDisplayValuesForKey:targetKey] sortedArrayUsingSelector:@selector(compare:)];
                            editor.selectedItemIndex = [editor.items indexOfObject:currentValue];
                        } else {
                            editor.items = [self.model.currentUser potentialDisplayValuesForKey:targetKey];
                            editor.selectedItemIndex = [[self.model.currentUser lookupIndexForKey:targetKey] unsignedIntegerValue];
                        }
                        
                        [self.navigationController pushViewController:editor animated:YES];
                    } else {
                        
                        GLUCListEditorViewController *editor = (GLUCListEditorViewController *) [[self storyboard] instantiateViewControllerWithIdentifier:kGLUCListEditorViewControllerIdentifier];
                        editor.editedObject = self.model.currentUser;
                        editor.editedProperty = targetKey;
                        editor.title = [self.model.currentUser titleForKey:targetKey];
                        editor.model = self.model;
                        
                        if ([self.model.currentUser propertyIsIndirectLookup:targetKey]) {
                            NSString *currentValue = [self.model.currentUser displayValueForKey:targetKey];
                            editor.items = [[self.model.currentUser potentialDisplayValuesForKey:targetKey] sortedArrayUsingSelector:@selector(compare:)];
                            editor.selectedItemIndex = [editor.items indexOfObject:currentValue];
                        } else {
                            editor.items = [self.model.currentUser potentialDisplayValuesForKey:targetKey];
                            editor.selectedItemIndex = [[self.model.currentUser lookupIndexForKey:targetKey] unsignedIntegerValue];
                        }
                        
                        [self.navigationController pushViewController:editor animated:YES];
                    }
                } else {
                    if ([targetKey isEqualToString:kGLUCUserAllowResearchUsePropertyKey]) {
                        BOOL enabled = [[self.model.currentUser valueForKey:kGLUCUserAllowResearchUsePropertyKey] boolValue];
                        [self.model.currentUser setValue:@(!enabled) forKey:kGLUCUserAllowResearchUsePropertyKey];
                        [self.model saveAll];
                        [self.settingsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    } else {
                        GLUCValueEditorViewController *editor = (GLUCValueEditorViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:kGLUCValueEditorViewControllerIdentifier];
                        editor.editedObject = self.model.currentUser;
                        editor.editedProperty = targetKey;
                        editor.title = [self.model.currentUser titleForKey:targetKey];
                        editor.model = self.model;
                        [self.navigationController pushViewController:editor animated:YES];
                    }

                }
            } else {
                if (self.welcomeMode) {
                    if ([self validToGetStarted]) {
                        [self getStarted:self.getStartedButton];
                    } else {
                        [self hintRequiredRows];
                    }
                }
            }
            break;
        case DATA_SECTION:
            switch(indexPath.row) {
                case 0:
                {
                    //export
                    [SVProgressHUD showWithStatus:GLUCLoc(@"activity_export_snackbar_1")];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self.model exportAll];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];

                            UIAlertController * alert=   [UIAlertController
                                                          alertControllerWithTitle:GLUCLoc(@"Export")
                                                          message:(GLUCLoc(@"Zip file created"))
                                                          preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:GLUCLoc(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            }];
                            
                            [alert addAction:okAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        });
                    });
                }
                    break;
                case 1:
                {
                    [self.model import];
                }
                    break;
                case 2:
                {
                    GLUCNightscoutSettingsViewController *editor = (GLUCNightscoutSettingsViewController *) [[self storyboard] instantiateViewControllerWithIdentifier:kGLUCNightscoutSettingsViewControllerIdentifier];
                                        
                    [self.navigationController pushViewController:editor animated:YES];
                }
                    break;
            }
            break;
        case ABOUT_SECTION:
            switch (indexPath.row) {
                case 0:
                {
                    GLUCAboutViewController *aboutViewController = (GLUCAboutViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:kGLUCAboutViewControllerIdentifier];
                    [self.navigationController pushViewController:aboutViewController animated:YES];
                }
                    break;
                case 1:
                    [self gotoEULAViewRequireConfirmation:NO];
                    break;
                default:
                {
                    GLUCPrivacyViewController *privacyViewController = (GLUCPrivacyViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:kGLUCPrivacyViewControllerIdentifier];
                    [self.navigationController pushViewController:privacyViewController animated:YES];
                }
                    break;
            }
            break;
        default:
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    if (self.welcomeMode) {
        unsigned long startingCellRow = (self.settingKeys.count);
        if (indexPath.row == startingCellRow) {
            cell = self.getStartedButtonCell;
            return cell;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kGLUCSettingsCellIdentifier];
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGLUCSettingsCellIdentifier];
    }

    NSArray *targetKeys = nil;

    switch (indexPath.section) {
        case DATA_SECTION:
            targetKeys = self.dataKeys;
            break;
        case ABOUT_SECTION:
            targetKeys = self.aboutKeys;
            break;
        case 0:
        default:
            targetKeys = self.settingKeys;
            break;
    }


    NSString *targetKey = (indexPath.row < targetKeys.count) ? targetKeys[(NSUInteger) indexPath.row] : @"";

    cell.textLabel.minimumScaleFactor = 0.25f;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [GLUCAppearanceController defaultFont];
    
    if (indexPath.row >= 0 && indexPath.row < [targetKeys count]) {
        if (indexPath.section == ABOUT_SECTION || indexPath.section == DATA_SECTION) {
            cell.textLabel.text = GLUCLoc(targetKey);
        } else {
            cell.textLabel.text = [self.model.currentUser titleForKey:targetKey];
        }
    }
    if ((indexPath.section == 0) && (indexPath.row < [targetKeys count])) {
        NSString *currentValue = [self.model.currentUser displayValueForKey:targetKey];
        cell.detailTextLabel.text = currentValue;
        cell.detailTextLabel.font = [GLUCAppearanceController defaultFont];
    }

    if ([targetKey isEqualToString:kGLUCUserAllowResearchUsePropertyKey]) {
        BOOL enabled = [[self.model.currentUser valueForKey:kGLUCUserAllowResearchUsePropertyKey] boolValue];
        if (enabled) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        cell.detailTextLabel.text = @"";
    } else {
        if (self.welcomeMode) {
            unsigned long starting_row = self.settingKeys.count + 1;
            if (indexPath.row != starting_row)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *retVal = nil;
    if (section == 0) {
        if (self.welcomeMode)
            retVal = GLUCLoc(@"helloactivity_hint_settings");
    }
    return retVal;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *retVal = @"";
    switch (section) {
        case DATA_SECTION:
            retVal = GLUCLoc(@"preferences_data");
            break;
        case ABOUT_SECTION:
            retVal = GLUCLoc(@"preferences_about");
            break;
        case 0:
        default:
            retVal = GLUCLoc(@"action_settings");
            break;
    }
    return retVal;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // We don't include the 'About' section if we are in welcome mode
    if (self.welcomeMode) {
        return 1;
    } else {
        return 3;
    }
}


- (void)openMailComposerWithAttachment
                                        :(NSData *)attachment
{
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Error"
                                            message:@"Cannot send mail."
                                     preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:
         [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * _Nonnull action) {
                                }]];

        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;

    mailComposer.subject = @"Glucosio Data Backup";

    [mailComposer setMessageBody:@"This is the full data backup" isHTML:false];

    [mailComposer addAttachmentData:attachment
                           mimeType:@"text/plain"
                           fileName:@"backup.txt"];

    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
