//
//  SamplePickerCollectionViewController.m
//  Simon :)
//
//  Created by Pratham Mehta on 26/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "SamplePickerCollectionViewController.h"

@interface SamplePickerCollectionViewController ()

@end

@implementation SamplePickerCollectionViewController

static NSString * const reuseIdentifier = @"sampleCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] resourcePath];
    
    NSArray *allFiles = [fm contentsOfDirectoryAtPath:path error:nil];
    
    self.audioSamples = [[NSMutableArray alloc] init];
    
    for(NSString *fileName in allFiles)
    {
        if([fileName hasSuffix:@".caf"])
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

- (NSMutableArray *)namesOfSelectedSamples
{
    if(!_namesOfSelectedSamples)
    {
        _namesOfSelectedSamples = [[NSMutableArray alloc] init];
    }
    return _namesOfSelectedSamples;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.audioSamples.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    SamplePreviewSelectView *view = (SamplePreviewSelectView *)[cell.contentView viewWithTag:1];
    view.name = [[self.audioSamples objectAtIndex:indexPath.row] stringByDeletingPathExtension];
    view.color = [UIColor colorWithRed:0.82 green:0.40 blue:0.24 alpha:1.0];
    [view setNeedsDisplay];
    
    if([self.namesOfSelectedSamples containsObject:view.name])
    {
        view.alpha = 0.5;
    }
    else
    {
        view.alpha = 1.0;
    }
    
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}


- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.namesOfSelectedSamples containsObject:[self.audioSamples objectAtIndex:indexPath.row]])
        return NO;
    else
        return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Singleton *shared = [Singleton sharedInstance];
    
    [shared.audioController removeChannels:shared.audioController.channels];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    SamplePreviewSelectView *view = (SamplePreviewSelectView *)[cell.contentView viewWithTag:1];
    NSString *name = view.name;
    
    NSLog(@"File selected: %@",name);
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:name
                                         withExtension:@"caf"];
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

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
