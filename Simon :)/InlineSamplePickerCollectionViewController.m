//
//  InlineSamplePickerCollectionViewController.m
//  Simon :)
//
//  Created by Pratham Mehta on 02/02/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "InlineSamplePickerCollectionViewController.h"

@interface InlineSamplePickerCollectionViewController ()

@end

@implementation InlineSamplePickerCollectionViewController

static NSString * const reuseIdentifier = @"inlineSampleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UICollectionViewCell alloc] init];
    }
    // Configure the cell
    
    return cell;
}



@end
