//
//  SamplePreviewSelectView.m
//  Simon :)
//
//  Created by Pratham Mehta on 26/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "SamplePreviewSelectView.h"

@implementation SamplePreviewSelectView

- (UIBezierPath *)circlePath
{
    if(!_circlePath)
    {
        _circlePath = [UIBezierPath bezierPathWithOvalInRect:self.circleRect];
    }
    return _circlePath;
}

- (NSString *)name
{
    if(!_name)
    {
        _name = @"Pratham is awesome";
    }
    return _name;
}

- (UIColor *)color
{
    if(!_color)
    {
        _color = [UIColor blackColor];
    }
    return _color;
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if(!_longPressGesture)
    {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnView:)];
    }
    return _longPressGesture;
}

- (UIImageView *)imageView
{
    
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.circleRect];
    }
    
    self.tintColor = [UIColor whiteColor];
    
    
    if([self.name.lowercaseString containsString:@"bass"] ||
       [self.name.lowercaseString containsString:@"guit"] ||
       [self.name.lowercaseString containsString:@"sarod"] ||
       [self.name.lowercaseString containsString:@"subahar"] ||
       [self.name.lowercaseString containsString:@"banjo"] ||
       [self.name.lowercaseString containsString:@"folk"] ||
       [self.name.lowercaseString containsString:@"mandolin"])
    {
        _imageView.image = [[UIImage imageNamed:@"guitar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
   
    else if ([self.name.lowercaseString containsString:@"drum"] ||
             [self.name.lowercaseString containsString:@"beat"] ||
             [self.name.lowercaseString containsString:@"conga"] ||
             [self.name.lowercaseString containsString:@"persantar"] ||
             [self.name.lowercaseString containsString:@"tambourine"] ||
             [self.name.lowercaseString containsString:@"maracas"] ||
             [self.name.lowercaseString containsString:@"natkick"] ||
             [self.name.lowercaseString containsString:@"synth"])
    {
        _imageView.image = [[UIImage imageNamed:@"drums.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else
    {
        _imageView.image = [[UIImage imageNamed:@"electro.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    _imageView.tintColor = [Singleton getColorForSample:self.name];
    NSLog(@"sample name in item: %@",self.name);
    
    return _imageView;
}

- (UILabel *)label
{
    if(!_label)
    {
        CGRect rect = self.bounds;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.height-30, rect.size.width, 30)];
        _label.numberOfLines = 2;
        _label.font = [UIFont systemFontOfSize:12];
    }
    return _label;
}

- (void) longPressOnView:(UILongPressGestureRecognizer *)recognizer
{
    [self removeGestureRecognizer:self.longPressGesture];
    Singleton *shared = [Singleton sharedInstance];
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        //[shared.audioController removeChannels:shared.audioController.channels];
        
        NSString *name = self.name;
        //NSLog(@"File selected: %@",name);
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:name
                                             withExtension:@"mp3"];
        NSError *error;
        
        self.testPlayer = [AEAudioFilePlayer audioFilePlayerWithURL:url
                                                    audioController:shared.audioController
                                                              error:&error];
        
        [shared.audioController addChannels:@[self.testPlayer]];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        //NSLog(@"Stop playing music");
        
        [shared.audioController removeChannels:@[self.testPlayer]];
    }
    
    [self addGestureRecognizer:self.longPressGesture];
}

- (void)drawRect:(CGRect)rect {
    
    self.circleRect = CGRectMake(20, 1, self.bounds.size.width-40, self.bounds.size.width-40);
    
    [[UIColor whiteColor] setFill];
    [self.circlePath fill];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *displayName = [self.name stringByReplacingOccurrencesOfString:self.packName
                                                                 withString:@""];
    displayName = [displayName stringByReplacingOccurrencesOfString:@"ZZZ"
                                                         withString:@""];
    
    [displayName drawInRect:CGRectMake(0, rect.size.height-30, rect.size.width, 30)
             withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                              NSParagraphStyleAttributeName:paragraphStyle,
                              NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    //    self.label.text = self.name;
    
    [self addGestureRecognizer:self.longPressGesture];
    
    
    //    if([self.name.lowercaseString containsString:@"bass"] || [self.name.lowercaseString containsString:@"guit"])
    //    {
    //        self.imageView.image = [UIImage imageNamed:@"guitar.png"];
    //    }
    //    else if ([self.name.lowercaseString containsString:@"clav"])
    //    {
    //        self.imageView.image = [UIImage imageNamed:@"saxophone.png"];
    //    }
    //    else if ([self.name.lowercaseString containsString:@"drum"] || [self.name.lowercaseString containsString:@"beat"])
    //    {
    //        self.imageView.image = [UIImage imageNamed:@"drums.png"];
    //    }
    //    else
    //    {
    //        self.imageView.image = [UIImage imageNamed:@"electro.png"];
    //    }
    
    [self addSubview:self.imageView];

    //    [self addSubview:self.label];
}


@end
