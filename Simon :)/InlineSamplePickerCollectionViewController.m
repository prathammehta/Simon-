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


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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



@end
