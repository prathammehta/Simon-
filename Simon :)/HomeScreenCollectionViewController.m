//
//  HomeScreenCollectionViewController.m
//  Simon
//
//  Created by Pratham Mehta on 24/04/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "HomeScreenCollectionViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:1];
    
    button.backgroundColor = [UIColor clearColor];
    button.userInteractionEnabled = NO;
    if(song.imageData)
    {
        [button setImage:[UIImage imageWithData:song.imageData] forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"newSong.png"] forState:UIControlStateNormal];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:2];
    
    label.text = song.name;
    label.alpha = 0;
    
    cell.clipsToBounds = NO;
    cell.layer.masksToBounds = NO;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [self.collectionView visibleCells];
    for(int i = 0; i < visibleCells.count; i++)
    {
        UICollectionViewCell *cell = [visibleCells objectAtIndex:i];
        
        UIButton *button = (UIButton *)[cell.contentView viewWithTag:1];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:2];
        
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:[self.collectionView indexPathForCell:cell]];
        
        CGRect cellRect = attributes.frame;
        
        CGRect cellFrameInSuperview = [self.collectionView convertRect:cellRect toView:[self.collectionView superview]];
        
        if((cellFrameInSuperview.origin.x + (cellFrameInSuperview.size.width/2) >= self.collectionView.superview.center.x - 100) &&
           (cellFrameInSuperview.origin.x + (cellFrameInSuperview.size.width/2) <= self.collectionView.superview.center.x + 100))
        {
            float distanceFromCenter = fabs(cellFrameInSuperview.origin.x + (cellFrameInSuperview.size.width/2) - self.collectionView.center.x);
            
            button.transform = CGAffineTransformMakeScale(1.0 + ((100.0-distanceFromCenter)/100.0),
                                                          1.0 + ((100.0-distanceFromCenter)/100.0));
            
            label.alpha = ((100.0-distanceFromCenter)/100.0) + 0.25;
            
        }
        else
        {
            button.transform = CGAffineTransformIdentity;
        }
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showSimon"])
    {
        ViewController *viewController = (ViewController *)segue.destinationViewController;
        viewController.didAppearFromNav = YES;
        [viewController performSelector:@selector(setSong:) withObject:[self.fetchedResultsController objectAtIndexPath:[self.collectionView indexPathsForSelectedItems].firstObject]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.25 animations:^{
        NSArray *visibleCells = [collectionView visibleCells];
        for(int i=0; i<visibleCells.count; i++)
        {
            if(![[collectionView indexPathForCell:((UICollectionViewCell *)visibleCells[i])] isEqual:indexPath])
            {
                ((UICollectionViewCell *)visibleCells[i]).alpha = 0;
            }
            else
            {
                [cell viewWithTag:2].hidden = YES;
            }
        }
    }];
    
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:0
                     animations:^{
                         cell.transform = CGAffineTransformMakeScale(self.collectionView.frame.size.width/200.0,
                                                                     self.collectionView.frame.size.width/200.0);
                     }
                     completion:^(BOOL success){
                         [self performSegueWithIdentifier:@"showSimon" sender:self];
                     }];
}

@end
