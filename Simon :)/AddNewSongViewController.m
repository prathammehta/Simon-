//
//  AddNewSongViewController.m
//  Simon
//
//  Created by Pratham Mehta on 06/07/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "AddNewSongViewController.h"
#import "Song+Operations.h"
#import "AppDelegate.h"

@interface AddNewSongViewController ()

@end

@implementation AddNewSongViewController



- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (IBAction)creatButtonPressed:(UIButton *)sender
{
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    [Song insertSongWithName:self.textField.text
                 withContext:context
               withImageData:nil];
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}
@end
