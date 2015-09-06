//
//  HomeScreenCollectionViewController.h
//  Simon
//
//  Created by Pratham Mehta on 24/04/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataCollectionViewController.h"
#import "Song+Operations.h"

@interface HomeScreenCollectionViewController : CoreDataCollectionViewController

- (void) selectLastCell;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic) BOOL editingModeActive;
@end
