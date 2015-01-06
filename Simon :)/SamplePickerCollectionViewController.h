//
//  SamplePickerCollectionViewController.h
//  Simon :)
//
//  Created by Pratham Mehta on 26/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "SamplePreviewSelectView.h"

@interface SamplePickerCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *audioSamples;
@property (nonatomic, strong) NSMutableArray *namesOfSelectedSamples;

@end
