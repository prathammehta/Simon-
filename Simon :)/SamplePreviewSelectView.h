//
//  SamplePreviewSelectView.h
//  Simon :)
//
//  Created by Pratham Mehta on 26/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheAmazingAudioEngine.h"
#import "Singleton.h"

@interface SamplePreviewSelectView : UIView

@property (nonatomic, strong) UIBezierPath *circlePath;
@property (nonatomic) CGRect circleRect;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *packName;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic) BOOL  isMusicPlaying;

@property (nonatomic, strong) AEAudioFilePlayer *testPlayer;

@end
