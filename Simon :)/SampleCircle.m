//
//  SampleCircle.m
//  Simon :)
//
//  Created by Pratham Mehta on 18/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "SampleCircle.h"

@implementation SampleCircle

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if(!_tapGestureRecognizer)
    {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleTapped:)];
    }
    return _tapGestureRecognizer;
}

- (void) circleTapped:(UITapGestureRecognizer *) recognizer
{
    NSLog(@"Circle Tapped");
    self.isMuted = !self.isMuted;
    [self setNeedsDisplay];
}

- (UIImageView *)imageView
{
    if(!_imageView)
    {
        self.tintColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        if([self.audioFileName.lowercaseString containsString:@"bass"] || [self.audioFileName.lowercaseString containsString:@"guit"])
        {
            _imageView.image = [[UIImage imageNamed:@"guitar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        else if ([self.audioFileName.lowercaseString containsString:@"clav"])
        {
            _imageView.image = [[UIImage imageNamed:@"saxophone.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        else if ([self.audioFileName.lowercaseString containsString:@"drum"] || [self.audioFileName.lowercaseString containsString:@"beat"])
        {
            _imageView.image = [[UIImage imageNamed:@"drums.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        else
        {
            _imageView.image = [[UIImage imageNamed:@"electro.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        _imageView.alpha = 0.5;
    }
    return _imageView;
}

- (void) updateValue:(EFCircularSlider *)slider
{
    if(slider.currentValue > 1 && slider.currentValue <= 1.1)
    {
        slider.currentValue = 1;
    }
    else if(slider.currentValue > 1 && slider.currentValue <= 1.2)
    {
        slider.currentValue = 0;
    }
    
    self.currentValue = slider.currentValue;
    
    Singleton *shared = [Singleton sharedInstance];
    AEAudioFilePlayer *player = [shared.audioFilePlayers objectAtIndex:self.sampleNumber];
    if(!self.isMuted)
        player.volume = slider.currentValue;
    else
        player.volume = 0;
}

- (void)drawRect:(CGRect)rect
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self.slider removeTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    self.slider = nil;
    
    for(CALayer *layar in self.layer.sublayers)
    {
        [layar removeFromSuperlayer];
    }
    
    self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, self.bounds.size.width-2, self.bounds.size.height-2)];
    
    Singleton *shared = [Singleton sharedInstance];
    AEAudioFilePlayer *player = [shared.audioFilePlayers objectAtIndex:self.sampleNumber];
    
    self.audioFileName = player.url.lastPathComponent;
    
    self.color = [Singleton getColorForSample:self.audioFileName];
    
    if(!self.isMuted)
    {
        self.slider.userInteractionEnabled = YES;
        
        [self.color setStroke];
        [self.color setFill];
        [self.path stroke];
        [self.path fill];
        
        Singleton *shared = [Singleton sharedInstance];
        AEAudioFilePlayer *player = [shared.audioFilePlayers objectAtIndex:self.sampleNumber];
        player.volume = self.slider.currentValue;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.slider.alpha = 1.0;
                         }];
    }
    else
    {
        self.slider.userInteractionEnabled = NO;
        
        [[UIColor darkGrayColor] setStroke];
        [[UIColor darkGrayColor] setFill];
        [self.path stroke];
        [self.path fill];

        
        Singleton *shared = [Singleton sharedInstance];
        AEAudioFilePlayer *player = [shared.audioFilePlayers objectAtIndex:self.sampleNumber];
        player.volume = 0.0;
    }
    
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-10,
                                                                   self.bounds.size.height - 25,
                                                                   20,
                                                                   20)];
    
    [self.deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    self.deleteButton.alpha = 0.5;
    [self.deleteButton addTarget:self action:@selector(deletePressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.slider];
    [self addSubview:self.deleteButton];
    
    
    
    
    if(self.currentValue != 0) self.slider.currentValue = self.currentValue;
    
    if(![self.gestureRecognizers containsObject:self.tapGestureRecognizer])
        [self addGestureRecognizer:self.tapGestureRecognizer];
    
    NSLog(@"File name: %@",self.audioFileName);
    
    [self.imageView setFrame:CGRectMake((self.bounds.size.width/2)-8, 12, 16, 16)];
    [self addSubview:self.imageView];
    
}

- (EFCircularSlider *) slider
{
    if(!_slider)
    {
        _slider = [[EFCircularSlider alloc] initWithFrame:self.bounds];
        _slider.lineWidth = 10;
        _slider.handleColor = [UIColor whiteColor];
        _slider.opaque = NO;
        _slider.filledColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _slider.unfilledColor = [UIColor clearColor];
        _slider.transform = CGAffineTransformMakeRotation(M_PI+0.5);
        _slider.maximumValue = 1.2;
        _slider.minimumValue = 0.0;
        _slider.currentValue = 0.999;
        
        [_slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (void) deletePressed
{
    Singleton *shared = [Singleton sharedInstance];
    AEAudioFilePlayer *player = [shared.audioFilePlayers objectAtIndex:self.sampleNumber];
    [shared.audioController removeChannels:@[player]];
    [shared.audioFilePlayers removeObject:player];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePressed" object:self];
}

@end
