//
//  NewInstrumentPickerView.m
//  Simon :)
//
//  Created by Pratham Mehta on 25/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "NewInstrumentPickerView.h"

@implementation NewInstrumentPickerView

@synthesize categoryCircles = _categoryCircles;
@synthesize categoryNames = _categoryNames;

- (NSMutableArray *) categoryNames
{
    if(!_categoryNames)
    {
        _categoryNames = [[NSMutableArray alloc] init];
    }
    return _categoryNames;
}

- (void) setCategoryNames:(NSMutableArray *)categoryNames
{
    _categoryNames = categoryNames;
    
    for(int i; i<_categoryNames.count; i++)
    {
        CategoryCircleView *circle = [[CategoryCircleView alloc] initWithFrame:CGRectMake(self.bounds.size.height/2 - 35,
                                                                                          self.bounds.size.height/2 - 35,
                                                                                          70,
                                                                                          70)];
        circle.backgroundColor = [UIColor clearColor];
        circle.opaque = NO;
        circle.alpha = 0;
        
        [self.categoryCircles addObject:circle];
        [self addSubview:circle];
    }
}

- (NSMutableArray *) categoryCircles
{
    if(!_categoryCircles)
    {
        _categoryCircles = [[NSMutableArray alloc] init];
    }
    return _categoryCircles;
}

- (void) splitCategories
{
    int i = 0;
    for(CategoryCircleView *circleView in self.categoryCircles)
    {
        [UIView animateWithDuration:0.2
                              delay:0 //i*0.05 All at once
//             usingSpringWithDamping:0.5
//              initialSpringVelocity:10
                            options:(UIViewAnimationOptionCurveEaseInOut)
                         animations:^(void){
                             CGPoint center = circleView.center;
                             center.x = center.x + 110*(cos(((i*360/[self.categoryCircles count])*(M_PI/180))-M_PI_2));
                             center.y = center.y + 110*(sin(((i*360/[self.categoryCircles count])*(M_PI/180))-M_PI_2));
                             circleView.center = center;
                             circleView.alpha = 1.0;}
                         completion:nil];
        i++;
    }
}

- (void) joinCategoriesWithCompletionHandler:(void (^)(void))completionHandler
{
    [UIView animateWithDuration:0.2
                     animations:^(void){
                         for(int i=0; i<[self.categoryCircles count];i++)
                         {
                             CategoryCircleView *circleView = [self.categoryCircles objectAtIndex:i];
                             CGRect centerFrame = CGRectMake(self.bounds.size.height/2 - 35, self.bounds.size.height/2 - 35, 70, 70);
                             circleView.frame = centerFrame;
                             circleView.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL success){
                         completionHandler();
                     }];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end