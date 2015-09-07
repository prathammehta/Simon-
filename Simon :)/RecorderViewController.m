//
//  RecorderViewController.m
//  Simon
//
//  Created by Pratham Mehta on 24/03/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "RecorderViewController.h"


@interface RecorderViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic) BOOL isRecording;
@property (nonatomic, strong) AEAudioFilePlayer *audioFilePlayer;
@property (nonatomic) TPAACAudioConverter *audioConverter;
@property (nonatomic, strong) NSString *mp3FilePath;
@property (nonatomic, strong) NSTimer *recodingDurationLabelUpdateTimer;
@property (nonatomic) NSInteger secondsRecorded;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL isRecordedFileAvailable;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

@implementation RecorderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timerLabel.text = @"REC";
    self.secondsRecorded = 0;
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.hidden = YES;
    self.activityIndicator.color = [UIColor whiteColor];
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
    
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"song.caf"];
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
    
    
    if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileCAFType error:&error] ) {
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
    
    float vocalStartMarker = 0.0f;
    float vocalEndMarker = 5.0f;
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"song.caf"];
    
    NSURL *audioFileInput = [NSURL fileURLWithPath:path]; // give your audio file path
    
    NSString *docsDirs;
    NSArray *dirPath;
    dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDirs = [dirPath objectAtIndex:0];
    NSString *destinationURLs = [docsDirs stringByAppendingPathComponent:@"trim.caf"];
    NSURL *audioFileOutput = [NSURL fileURLWithPath:destinationURLs];
    
    if (!audioFileInput || !audioFileOutput)
    {
        NSLog(@"Trimming failed. Couldn't find some file");
    }
    
    
    [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:audioFileInput options:nil];
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
                                                                            presetName:AVAssetExportPresetAppleM4A];
    if (exportSession == nil)
    {
        NSLog(@"Couldn't create export session");
    }
    
    CMTime startTime = CMTimeMake((int)(floor(vocalStartMarker * 100)), 100);
    CMTime stopTime = CMTimeMake((int)(ceil(vocalEndMarker * 100)), 100);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    exportSession.outputURL = audioFileOutput;
    
    NSLog(@"File types: %@",exportSession.supportedFileTypes);
    
    exportSession.timeRange = exportTimeRange;
    exportSession.outputFileType = exportSession.supportedFileTypes.firstObject;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^
     {
         if (AVAssetExportSessionStatusCompleted == exportSession.status)
         {
             // It worked!
             NSLog(@"[DONE TRIMMING.....");
             NSLog(@"ouput audio trim file %@",audioFileOutput);
         }
         else if (AVAssetExportSessionStatusFailed == exportSession.status)
         {
             // It failed...
             
             NSLog(@"FAILED TRIMMING..... Error: %@",exportSession.error);
         }
     }];
}

- (void) updateTimerLabel
{
    self.secondsRecorded++;
    self.timerLabel.text = [NSString stringWithFormat:@"%lds",(long)self.secondsRecorded];
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    
    if(self.isRecordedFileAvailable)
    {
        [self sendEmail];
    }
    else
    {
        if(!self.isRecording)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideShowChrome" object:nil];
            [self startRecording];
            self.timerLabel.text = @"0s";
            self.recodingDurationLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                                     target:self
                                                                                   selector:@selector(updateTimerLabel)
                                                                                   userInfo:nil
                                                                                    repeats:YES];
        }
        else
        {
            
            
            [self.recodingDurationLabelUpdateTimer invalidate];
            self.timerLabel.text = @"Working";
            self.secondsRecorded = 0;
            
            [self stopRecording];
            
            self.timerLabel.hidden = YES;
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            
            sender.userInteractionEnabled = NO;

            
            self.title = @"Working...";
            
            
            dispatch_async(dispatch_queue_create("mp3Queue", NULL), ^{
                
                NSArray *dirPaths;
                NSString *docsDir;
                
                
                dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                docsDir = [dirPaths objectAtIndex:0];
                NSString *cafFilePath = [docsDir stringByAppendingPathComponent:@"song.caf"];
                
                
                //[self cafToMp3:cafFilePath];
                
                [self performSelectorOnMainThread:@selector(prepareForConvertedFile) withObject:nil waitUntilDone:NO];
            });
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideShowChrome" object:nil];
            
            
            
            
            
            
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
    
}

- (void) prepareForConvertedFile
{
    self.timerLabel.text = @"Send!";
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.timerLabel.hidden = NO;
    self.isRecordedFileAvailable = YES;
    self.recordButton.userInteractionEnabled = YES;
}

- (void) sendEmail
{
    
    NSString *songName = [((NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"currentSongName"]) stringByAppendingString:@".mp3"];
    
    songName = @"song.caf";
    
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsFolder stringByAppendingPathComponent:songName];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
    
    UIActivityViewController *activityViewOCntroller = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL]
                                                                                         applicationActivities:nil];

    activityViewOCntroller.popoverPresentationController.sourceView = self.recordButton;
    
    [self presentViewController:activityViewOCntroller animated:YES completion:nil];
    
    activityViewOCntroller.completionWithItemsHandler = ^(NSString *activityType,
                                                          BOOL success,
                                                          NSArray *returnedItems,
                                                          NSError *error){
        Singleton *shared = [Singleton sharedInstance];
        
        [shared.audioController addChannels:shared.audioFilePlayers];
        
        self.isRecordedFileAvailable = NO;
        self.timerLabel.text = @"REC";
        self.secondsRecorded = 0;

    };
    
//    NSData *dataToSend = [[NSData alloc] initWithContentsOfURL:fileURL];
//    
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    picker.mailComposeDelegate = self;
//    
//    [picker setSubject:@"Recording"];
//    
//    // Set up recipients
//    NSArray *toRecipients = nil;
//    NSArray *ccRecipients = nil;
//    NSArray *bccRecipients = nil;
//    
//    [picker setToRecipients:toRecipients];
//    [picker setCcRecipients:ccRecipients];
//    [picker setBccRecipients:bccRecipients];
//    
//    [picker setSubject:@"♬♩ listen to my creation - created with Social Symphony"];
//    [picker setMessageBody:@"give your musical creatity wings to fly.\n Get started here: http://socialsymphonyapp.com" isHTML:YES];
//    [picker addAttachmentData:dataToSend mimeType:@"audio/mpeg" fileName:@"record.mp3"];
//    
//    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (void)cafToMp3:(NSString*)cafFileName
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSString *songName = [((NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"currentSongName"]) stringByAppendingString:@".mp3"];
    
    _mp3FilePath = [docsDir stringByAppendingPathComponent:songName];
    
    @try {
        int read, write;
        FILE *pcm = fopen([cafFileName cStringUsingEncoding:1], "rb");
        FILE *mp3 = fopen([_mp3FilePath cStringUsingEncoding:1], "wb");
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        //Detrming the size of mp3 file
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSData *data = [fileManger contentsAtPath:_mp3FilePath];
        NSString* str = [NSString stringWithFormat:@"%lu K",[data length]/1024];
        NSLog(@"size of mp3=%@",str);
        
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
}

- (void)startConverting:(NSString *) cafFilePath
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSString *songName = [((NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"currentSongName"]) stringByAppendingString:@".mp3"];
    
    _mp3FilePath = [docsDir stringByAppendingPathComponent:songName];
    
}


@end
