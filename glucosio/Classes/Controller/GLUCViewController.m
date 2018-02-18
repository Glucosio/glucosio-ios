
#import "GLUCViewController.h"
#import "GLUCAppDelegate.h"
#import "GLUCDataServiceNightscout.h"

@implementation GLUCViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.model) {
        self.model = [(GLUCAppDelegate *) [[UIApplication sharedApplication] delegate] appModel];
    }    

    self.numberFormatter = self.model.currentUser.numberFormatter;
    self.speechEnabled = YES;
    self.speechSynth = [[AVSpeechSynthesizer alloc] init];
}

- (IBAction) cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *) cancelButtonItem {
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    
    [cancelButton setTitle:GLUCLoc(@"Cancel") forState:UIControlStateNormal];
    [cancelButton.widthAnchor constraintEqualToConstant:80].active = YES;
    [cancelButton.heightAnchor constraintEqualToConstant:35].active = YES;
    
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

- (void) playAlarmSoundWithName:(NSString *)alarmSoundName {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:alarmSoundName ofType:@"wav"];
    if (soundPath) {
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

- (void) say:(NSString *)aString {
    if (self.speechEnabled) {
        if (self.speechSynth) {
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:aString];
            AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithIdentifier:@"com.apple.ttsbundle.siri_female_en-GB_compact"];
            if (voice)
                utterance.voice = voice;
            [self.speechSynth speakUtterance:utterance];
        }
    }
    self.speechEnabled = NO;
}

- (void) handleServiceAlarmNotification:(NSNotification *)alarmNotification {
    NSDictionary *alarmInfo = alarmNotification.userInfo;
    if (alarmInfo) {
        GLUCReading *reading = alarmInfo[@"reading"];
        GLUCDataServiceNightscout *service = alarmInfo[@"service"];
        NSLog(@"Checking reading for alarm criteria");
        if ([reading.reading floatValue] > [service.mgdLHighAlarmThreshold floatValue]) {
            self.speechEnabled = YES;
            NSLog(@"High alarm: %@ %@", reading.reading, service.mgdLHighAlarmThreshold);
            [self performSelector:@selector(playAlarmSoundWithName:) withObject:@"HighThreshold" afterDelay:2.0f];
        }
        if ([reading.reading floatValue] < [service.mgdLLowAlarmThreshold floatValue]) {
            self.speechEnabled = YES;
            NSLog(@"Low alarm: %@ %@", reading.reading, service.mgdLLowAlarmThreshold);
            [self playAlarmSoundWithName:@"LowThreshold"];
            for (float delay = 0.5; delay < 1.5; delay += 0.5) {
                [self performSelector:@selector(playAlarmSoundWithName:) withObject:@"LowThreshold" afterDelay:delay];
            }
        }

    }
}

@end
