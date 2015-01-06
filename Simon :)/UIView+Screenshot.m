//
//  UIView+Screenshot.m
//  Spendings
//
//  Created by Pratham Mehta on 04/03/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *) convertViewToImage
{
    UIImage *image;
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
