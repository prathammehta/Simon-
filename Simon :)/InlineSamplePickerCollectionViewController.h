//
//  InlineSamplePickerCollectionViewController.h
//  Simon :)
//
//  Created by Pratham Mehta on 02/02/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "SamplePreviewSelectView.h"

@interface InlineSamplePickerCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSString *filterString;

@end
