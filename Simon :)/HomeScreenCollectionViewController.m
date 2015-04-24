//
//  HomeScreenCollectionViewController.m
//  Simon
//
//  Created by Pratham Mehta on 24/04/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "HomeScreenCollectionViewController.h"
#import "AppDelegate.h"

@interface HomeScreenCollectionViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation HomeScreenCollectionViewController

static NSString * const reuseIdentifier = @"songCell";

- (void)viewDidLoad
{
    self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateOfCreation" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    [super viewDidLoad];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    return cell;
}

@end
