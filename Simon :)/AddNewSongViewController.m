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
#import "HomeScreenCollectionViewController.h"

@interface AddNewSongViewController ()

@end

@implementation AddNewSongViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textField becomeFirstResponder];
}

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
    
    [context save:nil];
    
    
    [self.presentingViewController dismissViewControllerAnimated:NO
                                                      completion:^{
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLastCell"
                                                                                                              object:nil];
                                                      }];
}
@end
