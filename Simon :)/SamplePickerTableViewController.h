//
//  SamplePickerTableViewController.h
//  Simon :)
//
//  Created by Pratham Mehta on 17/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "TheAmazingAudioEngine.h"

@interface SamplePickerTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *audioSamples; //of Strings

@end
