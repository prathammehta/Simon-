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
        self.tintColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:self.circleRect];
        _imageView.image = [[UIImage imageNamed:@"play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];;
    }
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
    
    self.circleRect = CGRectMake(5, 1, self.bounds.size.width-10, self.bounds.size.width-10);
    
    [self.color setFill];
    [self.circlePath fill];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [self.name drawInRect:CGRectMake(0, rect.size.height-30, rect.size.width, 30)
           withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                            NSParagraphStyleAttributeName:paragraphStyle,
                            NSForegroundColorAttributeName:[UIColor blackColor]}];
    
//    self.label.text = self.name;
    
    [self addGestureRecognizer:self.longPressGesture];
    [self addSubview:self.imageView];
//    [self addSubview:self.label];
}


@end
