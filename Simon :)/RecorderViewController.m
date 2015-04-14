//
//  RecorderViewController.m
//  Simon
//
//  Created by Pratham Mehta on 24/03/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "RecorderViewController.h"

@interface RecorderViewController () <MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate, TPAACAudioConverterDelegate>

@property (nonatomic) BOOL isRecording;
@property (nonatomic, strong) AEAudioFilePlayer *audioFilePlayer;
@property (nonatomic) TPAACAudioConverter *audioConverter;

@end

@implementation RecorderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (AEAudioController *)audioController
{
    if(!_audioController)
    {
        _audioController = [Singleton sharedInstance].audioController;
    }
    return _audioController;
}

- (AERecorder *)recorder
{
    if(_recorder)
    {
        _recorder = [[AERecorder alloc] initWithAudioController:self.audioController];
    }
    return _recorder;
}

- (void) startRecording
{
    self.recorder = [[AERecorder alloc] initWithAudioController:self.audioController];
    
    NSLog(@"AAC Encoding possible: %d",[AERecorder AACEncodingAvailable]);
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"song.m4a"];
    NSError *error = nil;
    
//    [_recorder prepareRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error];
//    
//    if(error)
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Error"
//                                    message:[NSString stringWithFormat:@"Couldn't prepare to record: %@", [error localizedDescription]]
//                                   delegate:nil
//                          cancelButtonTitle:nil
//                          otherButtonTitles:@"OK", nil] show];
//        self.recorder = nil;
//        return;
//    }
//    
//    AERecorderStartRecording(self.recorder);
//    
    
    
    if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error] ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        self.recorder = nil;
        return;
    }
    
    [_audioController addInputReceiver:_recorder];
    [_audioController addOutputReceiver:_recorder];
    self.isRecording = YES;
}

- (void) stopRecording
{
    [self.audioController removeInputReceiver:self.recorder];
    [self.audioController removeOutputReceiver:self.recorder];
    [self.recorder finishRecording];
    self.isRecording = NO;
//    self.recorder = nil;
}


- (IBAction)buttonPressed:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideShowChrome" object:nil];
    
    if(!self.isRecording)
    {
        [sender setTitle:@"Recording..." forState:UIControlStateNormal];
        [self startRecording];
    }
    else
    {
        [self stopRecording];
        
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        
        [self.audioController removeChannels:self.audioController.channels];
        
        NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [documentsFolder stringByAppendingPathComponent:@"song.m4a"];
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
        NSData *dataToSend = [[NSData alloc] initWithContentsOfURL:fileURL];
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:@"Recording"];
        
        // Set up recipients
        NSArray *toRecipients = nil;
        NSArray *ccRecipients = nil;
        NSArray *bccRecipients = nil;
        
        [picker setToRecipients:toRecipients];
        [picker setCcRecipients:ccRecipients];
        [picker setBccRecipients:bccRecipients];
        
        [picker setMessageBody:@"" isHTML:YES];
        [picker addAttachmentData:dataToSend mimeType:@"audio/mp4a-latm" fileName:@"song.m4a"];
        
        [self presentViewController:picker animated:YES completion:nil];
        
        //self.audioController = nil;

        //[self convert];
        
        
// Code to test if the recorded file is any good :P

//        
//        if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] )
//        {
//            NSLog(@"No file exists");
//            return;
//        }
//        
//        
//        NSError *error = nil;
//        self.audioFilePlayer = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] audioController:_audioController error:&error];
//        
//        if ( !self.audioFilePlayer )
//        {
//            [[[UIAlertView alloc] initWithTitle:@"Error"
//                                        message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
//                                       delegate:nil
//                              cancelButtonTitle:nil
//                              otherButtonTitles:@"OK", nil] show];
//            return;
//        }
//        
//        self.audioFilePlayer.removeUponFinish = YES;
//        [_audioController addChannels:@[self.audioFilePlayer]];

        
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}















- (void) convert
{
    if ( ![TPAACAudioConverter AACConverterAvailable] ) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                    message:NSLocalizedString(@"Couldn't convert audio: Not supported on this device", @"")
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
        return;
    }
    
    // Register an Audio Session interruption listener, important for AAC conversion
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterrupted:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    
    // Set up an audio session compatible with AAC conversion.  Note that AAC conversion is incompatible with any session that provides mixing with other device audio.
    NSError *error = nil;
    if ( ![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           withOptions:0
                                                 error:&error] ) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                    message:[NSString stringWithFormat:NSLocalizedString(@"Couldn't setup audio category: %@", @""), error.localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        return;
    }
    
    // Activate audio session
    if ( ![[AVAudioSession sharedInstance] setActive:YES error:NULL] ) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                    message:[NSString stringWithFormat:NSLocalizedString(@"Couldn't activate audio category: %@", @""), error.localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        return;
        
    }
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.audioConverter = [[TPAACAudioConverter alloc] initWithDelegate:self
                                                                 source:[[NSBundle mainBundle] pathForResource:@"song" ofType:@"caf"]
                                                            destination:[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:@"audio.m4a"]];

    [_audioConverter start];
}


#pragma mark - Audio converter delegate

-(void)AACAudioConverter:(TPAACAudioConverter *)converter didMakeProgress:(CGFloat)progress {
    //self.progressView.progress = progress;
    NSLog(@"Progress on conversion: %f",progress);
}

-(void)AACAudioConverterDidFinishConversion:(TPAACAudioConverter *)converter {

    self.audioConverter = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *path = [documentsFolder stringByAppendingPathComponent:@"audio.m4a"];
//    
//    
//            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
//            NSData *dataToSend = [[NSData alloc] initWithContentsOfURL:fileURL];
//    
//            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//            picker.mailComposeDelegate = self;
//    
//            [picker setSubject:@"Recording"];
//    
//            // Set up recipients
//            NSArray *toRecipients = nil;
//            NSArray *ccRecipients = nil;
//            NSArray *bccRecipients = nil;
//    
//            [picker setToRecipients:toRecipients];
//            [picker setCcRecipients:ccRecipients];
//            [picker setBccRecipients:bccRecipients];
//    
//            [picker setMessageBody:@"" isHTML:YES];
//            [picker addAttachmentData:dataToSend mimeType:@"audio/mp4a-latm" fileName:@"audio.m4a"];
//    
//            [self presentViewController:picker animated:YES completion:nil];
}

-(void)AACAudioConverter:(TPAACAudioConverter *)converter didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Converting audio", @"")
                                message:[NSString stringWithFormat:NSLocalizedString(@"Couldn't convert audio: %@", @""), [error localizedDescription]]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil] show];
    self.audioConverter = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Audio session interruption

- (void)audioSessionInterrupted:(NSNotification*)notification {
    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
    
    if ( type == AVAudioSessionInterruptionTypeEnded) {
        [[AVAudioSession sharedInstance] setActive:YES error:NULL];
        if ( _audioConverter ) [_audioConverter resume];
    } else if ( type == AVAudioSessionInterruptionTypeBegan ) {
        if ( _audioConverter ) [_audioConverter interrupt];
    }
}

@end
