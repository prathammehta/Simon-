//
//  CoreDataCollectionViewController.h
//  Spendings
//
//  Created by Pratham Mehta on 28/03/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL debug;

@property (nonatomic, strong) NSMutableArray *sectionChanges;
@property (nonatomic, strong) NSMutableArray *itemChanges;

- (void) performFetch;

@end
