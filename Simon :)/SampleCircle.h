//
//  SampleCircle.h
//  Simon :)
//
//  Created by Pratham Mehta on 18/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFCircularSlider.h"
#import "Singleton.h"

@interface SampleCircle : UIView

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) EFCircularSlider *slider;
@property (nonatomic) float currentValue;
@property (nonatomic) NSInteger sampleNumber;

@end
