//
//  AboutUsViewController.m
//  Simon
//
//  Created by Pratham Mehta on 14/04/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (IBAction)donePressed:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
