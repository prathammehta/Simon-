//
//  InlineSamplePickerCollectionViewController.m
//  Simon :)
//
//  Created by Pratham Mehta on 02/02/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "InlineSamplePickerCollectionViewController.h"

@interface InlineSamplePickerCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *audioSamples;
@property (nonatomic, strong) NSMutableArray *namesOfSelectedSamples;

@end

@implementation InlineSamplePickerCollectionViewController

static NSString * const reuseIdentifier = @"inlineSampleCell";

@synthesize filterString = _filterString;

- (NSString *)filterString
{
    if(!_filterString)
    {
        _filterString = @"California";
    }
    return _filterString;
}

- (void)setFilterString:(NSString *)filterString
{
    _filterString = filterString;
    [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(packPickerTapped:) name:@"packPickerTapped" object:nil];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] resourcePath];
    
    NSArray *allFiles = [fm contentsOfDirectoryAtPath:path error:nil];
    
    self.audioSamples = [[NSMutableArray alloc] init];
    
    for(NSString *fileName in allFiles)
    {
        if([fileName hasSuffix:@".mp3"])
        {
            [self.audioSamples addObject:fileName];
        }
    }
    
    [self getNameOfSelectedSamples];
}

- (void) packPickerTapped:(NSNotification *)notification
{
    self.audioSamples = @[].mutableCopy;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] resourcePath];
    
    NSArray *allFiles = [fm contentsOfDirectoryAtPath:path error:nil];
    
    self.audioSamples = [[NSMutableArray alloc] init];
    
    for(NSString *fileName in allFiles)
    {
        if([fileName hasSuffix:@".mp3"])
        {
            [self.audioSamples addObject:fileName];
        }
    }
    
    NSNumber *number = (NSNumber *)notification.object;
    
    self.filterString = [Singleton getPackNameForNumber:number.integerValue];
    
    NSLog(@"Filter String: %@",self.filterString);
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


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *temp = [self.audioSamples copy];
    
    for(NSString *string in temp)
    {
        if(![string containsString:self.filterString])
        {
            [self.audioSamples removeObject:string];
        }
    }
    
    NSLog(@"Audio samples: %@",self.audioSamples);
    return self.audioSamples.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    SamplePreviewSelectView *view = (SamplePreviewSelectView *)[cell.contentView viewWithTag:1];
    view.name = [[self.audioSamples objectAtIndex:indexPath.row] stringByDeletingPathExtension];
    view.color = [UIColor colorWithRed:0.82 green:0.40 blue:0.24 alpha:1.0];
    [view setNeedsDisplay];
    
    if([self.namesOfSelectedSamples containsObject:[self.audioSamples objectAtIndex:indexPath.row]])
    {
        cell.alpha = 0.5;
    }
    else
    {
        cell.alpha = 1.0;
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.namesOfSelectedSamples containsObject:[self.audioSamples objectAtIndex:indexPath.row]])
        return NO;
    else
        return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMusic" object:nil];
    
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally|UICollectionViewScrollPositionCenteredVertically
                                   animated:YES];
    
    
    
    Singleton *shared = [Singleton sharedInstance];
    
    [shared.audioController removeChannels:shared.audioController.channels];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    SamplePreviewSelectView *view = (SamplePreviewSelectView *)[cell.contentView viewWithTag:1];
    NSString *name = view.name;
    
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:name
                                         withExtension:@"mp3"];
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
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeMusic" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sampleAdded" object:player];
    });
    
    
}

@end
