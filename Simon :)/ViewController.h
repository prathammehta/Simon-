//
//  ViewController.h
//  Simon :)
//
//  Created by Pratham Mehta on 16/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleCircle.h"
#import "TheAmazingAudioEngine.h"
#import "Singleton.h"
#import "Song+Operations.h"
#import "NewInstrumentPickerView.h"
#import "AKPickerView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *addSampleButton;
@property (nonatomic, strong) NSMutableArray *sampleCircles; //Of SampleCircles
@property (weak, nonatomic) IBOutlet UIView *circleContainerView;
@property (nonatomic, strong) Song *song;
@property (nonatomic) BOOL didAppearFromNav;
@property (weak, nonatomic) IBOutlet UIView *inlinePickerView;
@property (weak, nonatomic) IBOutlet AKPickerView *packPicker;
@property (nonatomic) NSUInteger maxNumberOfCircles;

@end

