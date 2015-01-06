//
//  CategoryCircleView.h
//  Spendings - Easily manage your money
//
//  Created by Pratham Mehta on 12/06/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCircleView : UIView

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *categoryColor;
@property (nonatomic) BOOL nameNeeded;

- (void) setCategoryColor:(UIColor *)color andSetCategoryName:(NSString *)name nameNeeded:(BOOL)nameNeeded;
- (void) flipToShowCompletionWithCompletionHandler:(void (^)(void))completionHandler;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecogniser;

@end
