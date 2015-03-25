//
//  RecorderViewController.m
//  Simon
//
//  Created by Pratham Mehta on 24/03/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "RecorderViewController.h"

@interface RecorderViewController () <MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic) BOOL isRecording;
@property (nonatomic, strong) AEAudioFilePlayer *audioFilePlayer;

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
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"song.caf"];
    NSError *error = nil;
    
    if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileCAFType error:&error] ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        self.recorder = nil;
        return;
    }
    

    
    [_audioController addOutputReceiver:_recorder];
    [_audioController addInputReceiver:_recorder];
    self.isRecording = YES;
}

- (void) stopRecording
{
    [self.audioController removeInputReceiver:self.recorder];
    [self.audioController removeOutputReceiver:self.recorder];
    [self.recorder finishRecording];
    self.isRecording = NO;
    self.recorder = nil;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
{

}

- (IBAction)buttonPressed:(UIButton *)sender
{
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
        NSString *path = [documentsFolder stringByAppendingPathComponent:@"song.caf"];

        
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
        [picker addAttachmentData:dataToSend mimeType:@"audio/x-caf" fileName:@"song.caf"];
        
        [self presentViewController:picker animated:YES completion:nil];
        
        
        
// Code to test if the recorded file is any good :P
//
//        
//        if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
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

@end
