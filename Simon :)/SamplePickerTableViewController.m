//
//  SamplePickerTableViewController.m
//  Simon :)
//
//  Created by Pratham Mehta on 17/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "SamplePickerTableViewController.h"

@interface SamplePickerTableViewController ()

@property (nonatomic, strong) AEAudioFilePlayer *testPlayer;
@property (nonatomic, strong) NSMutableArray *namesOfSelectedSamples;

@end

@implementation SamplePickerTableViewController

- (void) setAudioSamples:(NSMutableArray *)audioSamples
{
    _audioSamples = audioSamples;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] resourcePath];
    
    NSArray *allFiles = [fm contentsOfDirectoryAtPath:path error:nil];
    
    self.audioSamples = [[NSMutableArray alloc] init];
    
    for(NSString *fileName in allFiles)
    {
        if([fileName hasSuffix:@".wav"])
        {
            [self.audioSamples addObject:fileName];
        }
    }
    
    [self getNameOfSelectedSamples];
}

- (void) getNameOfSelectedSamples
{
    Singleton *shared = [Singleton sharedInstance];
    
    for(AEAudioFilePlayer *player in shared.audioFilePlayers)
    {
        NSURL *url = player.url;
        NSString *name = [url lastPathComponent];
        [self.namesOfSelectedSamples addObject:name];
    }
}

- (NSMutableArray *) namesOfSelectedSamples
{
    if(!_namesOfSelectedSamples)
    {
        _namesOfSelectedSamples = [[NSMutableArray alloc] init];
    }
    return _namesOfSelectedSamples;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.audioSamples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sampleCell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.audioSamples objectAtIndex:indexPath.row] stringByDeletingPathExtension];
    
    
    if([self.namesOfSelectedSamples containsObject:[self.audioSamples objectAtIndex:indexPath.row]])
    {
        cell.detailTextLabel.text = @"Already Added";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.detailTextLabel.text = @"                ";
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } 
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.namesOfSelectedSamples containsObject:[self.audioSamples objectAtIndex:indexPath.row]])
        return NO;
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Singleton *shared = [Singleton sharedInstance];
    
    if([shared.audioController.channels containsObject:self.testPlayer])
    {
        [shared.audioController removeChannels:@[self.testPlayer]];
        self.testPlayer = nil;
    }
    
    NSString *name = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSLog(@"File selected: %@",name);

    
    NSURL *url = [[NSBundle mainBundle] URLForResource:name
                                         withExtension:@"wav"];
    NSError *error;
    
    AEAudioFilePlayer *player = [AEAudioFilePlayer audioFilePlayerWithURL:url
                                                          audioController:shared.audioController
                                                                    error:&error];
    player.loop = YES;
    
    if(error)
    {
        NSLog(@"%@",error);
    }
    else
    {
        [shared.audioFilePlayers addObject:player];
        NSLog(@"Number of tracks playing: %ld",(long)shared.audioFilePlayers.count);
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeMusic" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sampleAdded" object:nil];
    }];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Singleton *shared = [Singleton sharedInstance];
    
    if([shared.audioController.channels containsObject:self.testPlayer])
    {
        [shared.audioController removeChannels:@[self.testPlayer]];
        self.testPlayer = nil;
    }
    
    NSString *name = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSLog(@"File selected: %@",name);
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:name
                                         withExtension:@"wav"];
    NSError *error;
    
    self.testPlayer = [AEAudioFilePlayer audioFilePlayerWithURL:url
                                                audioController:shared.audioController
                                                          error:&error];
    [shared.audioController addChannels:@[self.testPlayer]];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    Singleton *shared = [Singleton sharedInstance];
    
    if([shared.audioController.channels containsObject:self.testPlayer])
    {
        [shared.audioController removeChannels:@[self.testPlayer]];
        self.testPlayer = nil;
    }
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          [shared.audioController addChannels:shared.audioFilePlayers];
                                                      }];
}

@end
