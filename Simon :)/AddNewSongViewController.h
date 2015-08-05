//
//  AddNewSongViewController.h
//  Simon
//
//  Created by Pratham Mehta on 06/07/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewSongViewController : UIViewController

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)creatButtonPressed:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
