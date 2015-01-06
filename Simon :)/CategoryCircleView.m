//
//  CategoryCircleView.m
//  Spendings - Easily manage your money
//
//  Created by Pratham Mehta on 12/06/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "CategoryCircleView.h"
#import "Singleton.h"

@implementation CategoryCircleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:self.tapGestureRecogniser];
        self.nameNeeded = YES;
    }
    return self;
}

- (UITapGestureRecognizer *) tapGestureRecogniser
{
    if(!_tapGestureRecogniser)
    {
        _tapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleTapped)];
    }
    return _tapGestureRecogniser;
}

- (void) circleTapped
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"insturmentCategoryTapped" object:self.categoryName];
}

// All setters and getters

- (UIColor *) categoryColor
{
    if(!_categoryColor)
    {
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        _categoryColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    }
    return _categoryColor;
}

- (NSString *) categoryName
{
    if(!_categoryName)
    {
        Singleton *shared = [Singleton sharedInstance];
        _categoryName = [shared getNameForPicker];
    }
    return _categoryName;
}


- (void) setCategoryColor:(UIColor *)color andSetCategoryName:(NSString *)name nameNeeded:(BOOL)nameNeeded
{
    self.categoryColor = color;
    self.categoryName = name;
    self.nameNeeded = nameNeeded;
    [self setNeedsDisplay];
}

//Drawing code

- (void)drawRect:(CGRect)rect
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }

    CGRect drawingRect = rect;
    
    if(self.nameNeeded)
    {
        drawingRect.size.height = drawingRect.size.height-15;
        drawingRect.size.width = drawingRect.size.width-15;
        drawingRect.origin.x = drawingRect.origin.x+7.5;
        drawingRect.origin.y = drawingRect.origin.y+3;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentCenter;

        [self.categoryName drawInRect:CGRectMake(0, rect.size.height-12, rect.size.width, 12)
                       withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],
                                        NSParagraphStyleAttributeName:paragraphStyle,
                                        NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    else
    {
        drawingRect.size.height = drawingRect.size.height-10;
        drawingRect.size.width = drawingRect.size.width-10;
        drawingRect.origin.x = drawingRect.origin.x+5;
        drawingRect.origin.y = drawingRect.origin.y+5;
    }
    
    [self.categoryColor setStroke];
    [self.categoryColor setFill];
    

    if(self.nameNeeded)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShadowWithColor(context, CGSizeZero, 1, [UIColor blackColor].CGColor);
    }
    else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShadowWithColor(context, CGSizeZero, 5, [UIColor blackColor].CGColor);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:drawingRect];
    path.lineWidth = 2.0;
    //[path stroke];
    [path fill];
    
    UIImage *image = [UIImage imageNamed:self.categoryName.lowercaseString];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    CGRect imageRect = drawingRect;
    imageRect.size.height -= 20;
    imageRect.size.width -= 20;
    imageRect.origin.x += 10;
    imageRect.origin.y += 10;
    
    if(!image)
    {
        char c = [self.categoryName characterAtIndex:0];
        NSString *firstLetter = [NSString stringWithFormat:@"%c",c];
        UILabel *label = [[UILabel alloc] initWithFrame:imageRect];
        label.text = firstLetter;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:25];
        
        [self addSubview:label];
    }
    else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        imageView.tintColor = [UIColor whiteColor];
        [self addSubview:imageView];
    }
    
    
}

- (void) flipToShowCompletionWithCompletionHandler:(void (^)(void))completionHandler
{
    UIColor *tempColor = self.categoryColor;
    NSString *tempName = self.categoryName;
    [UIView transitionWithView:self
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.categoryName = @"Added";
                        self.categoryColor = [UIColor greenColor];
                        [self setNeedsDisplay];
                    }
                    completion:^(BOOL success){
                        [UIView transitionWithView:self
                                          duration:0.2
                                           options:UIViewAnimationOptionTransitionFlipFromLeft
                                        animations:^{
                                            [NSThread sleepForTimeInterval:0.5];
                                            self.categoryName = tempName;
                                            self.categoryColor = tempColor;
                                            [self setNeedsDisplay];
                                        }
                                        completion:^(BOOL success){
                                            completionHandler();
                                        }];
                    }];
}

@end