//
//  NewInstrumentPickerView.h
//  Simon :)
//
//  Created by Pratham Mehta on 25/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryCircleView.h"

@interface NewInstrumentPickerView : UIView

@property (nonatomic, strong) NSMutableArray *categoryCircles;
@property (nonatomic, strong) NSMutableArray *categoryNames;

- (void) joinCategoriesWithCompletionHandler:(void (^)(void))completionHandler;
- (void) splitCategories;

@end
