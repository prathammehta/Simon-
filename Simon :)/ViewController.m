//
//  ViewController.m
//  Simon :)
//
//  Created by Pratham Mehta on 16/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Screenshot.h"

@interface ViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) NewInstrumentPickerView *picker;
@property (nonatomic, strong) UIImageView *blurredView;
@property (nonatomic, strong) UIButton *dismissMenuButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupShadows];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewCircle) name:@"sampleAdded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCircle:) name:@"deletePressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeMusic) name:@"resumeMusic" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insturmentCategoryTapped:)
                                                 name:@"insturmentCategoryTapped"
                                               object:nil];
}

- (NSMutableArray *)sampleCircles
{
    if(!_sampleCircles)
    {
        _sampleCircles = [[NSMutableArray alloc] init];
    }
    return _sampleCircles;
}

- (NewInstrumentPickerView *) picker
{
    if(!_picker)
    {
        _picker = [[NewInstrumentPickerView alloc] initWithFrame:CGRectMake(0,
                                                                            self.view.bounds.size.height/2 - 160,
                                                                            320,
                                                                            320)];
        
        _picker.categoryNames = @[@"Piano",@"Guitar",@"Drum",@"Trumpet",@"Sitar",@"Violin"].mutableCopy;
    }
    return _picker;
}

- (UIImageView *)blurredView
{
    if(!_blurredView)
    {
        _blurredView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _blurredView;
}

- (UIButton *) dismissMenuButton
{
    if(!_dismissMenuButton)
    {
        _dismissMenuButton = [[UIButton alloc] initWithFrame:self.view.bounds];
        _dismissMenuButton.backgroundColor = [UIColor clearColor];
        [_dismissMenuButton addTarget:self action:@selector(removeMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissMenuButton;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self startInitialAnimations];
}

- (void) startInitialAnimations
{
    [UIView animateWithDuration:1.0
                          delay:0
                        options:(UIViewAnimationOptionRepeat|
                                 UIViewAnimationOptionAutoreverse|
                                 UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.addSampleButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
                     }
                     completion:^(BOOL success){
                         self.addSampleButton.transform = CGAffineTransformIdentity;
                     }];
}

- (void) setupShadows
{
    self.addSampleButton.layer.shadowRadius = 3.0;
    self.addSampleButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.addSampleButton.layer.shadowOpacity = 0.5;
}

- (void) addNewCircle
{
    
    SampleCircle *circle = [[SampleCircle alloc] initWithFrame:CGRectZero];
    
    [self.sampleCircles addObject:circle];
    
    circle.sampleNumber = self.sampleCircles.count - 1;
    
    NSInteger radius = 60+60*self.sampleCircles.count;
    
    circle.frame = CGRectMake(self.circleContainerView.bounds.size.width/2 - radius/2,
                              self.circleContainerView.bounds.size.width/2 - radius/2,
                              radius,
                              radius);
    
    
    
    circle.backgroundColor = [UIColor clearColor];
    
    circle.opaque = NO;
    
    circle.layer.shadowRadius = 3.0;
    circle.layer.shadowOffset = CGSizeMake(0, 0);
    circle.layer.shadowOpacity = 0.5;
    circle.alpha = 0;
    circle.transform = CGAffineTransformMakeScale(0.6, 0.6);
    
    [self.circleContainerView addSubview:circle];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:0
                     animations:^{
                         circle.alpha = 1.0;
                         circle.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
    
    [self.circleContainerView sendSubviewToBack:circle];
    
    
}

- (void) removeCircle:(NSNotification *)notification
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"deletePressed" object:nil];
    
    SampleCircle *circle = notification.object;
    
    [self.sampleCircles removeObject:circle];
    
    for(SampleCircle *circle in self.sampleCircles)
    {
        circle.sampleNumber = [self.sampleCircles indexOfObject:circle];
    }
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:0
                     animations:^{
                         circle.alpha = 0;
                         circle.transform = CGAffineTransformMakeScale(0.7, 0.7);
                     }
                     completion:^(BOOL success){
                         [circle removeFromSuperview];
                     }];
    [self redrawSampleCircles];
}

- (void) redrawSampleCircles
{
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options:0
                     animations:^{
                         for(SampleCircle *circle in self.sampleCircles)
                         {
                             NSInteger radius = 60+60*([self.sampleCircles indexOfObject:circle]+1);
                             float scale = radius/circle.bounds.size.height;
                             circle.transform = CGAffineTransformMakeScale(scale,scale);

                         }
                     }
                     completion:^(BOOL success){
                         for(SampleCircle *circle in self.sampleCircles)
                         {
                             circle.transform = CGAffineTransformIdentity;
                             NSInteger radius = 60+60*([self.sampleCircles indexOfObject:circle]+1);
                             //circle.sampleNumber = [self.sampleCircles indexOfObject:circle];
                             circle.frame = CGRectMake(self.circleContainerView.bounds.size.width/2 - radius/2,
                                                       self.circleContainerView.bounds.size.width/2 - radius/2,
                                                       radius, radius);
                             [circle setNeedsDisplay];
                             //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCircle:) name:@"deletePressed" object:nil];
                         }
                     }];
}

- (void) stopMusic
{
    Singleton *shared = [Singleton sharedInstance];
    [shared.audioController removeChannels:shared.audioFilePlayers];
    for(AEAudioFilePlayer *player in shared.audioFilePlayers)
    {
        player.currentTime = 0;
    }
}

- (void) resumeMusic
{
    Singleton *shared = [Singleton sharedInstance];
    [shared.audioController addChannels:shared.audioFilePlayers];
}

- (void) removeMenu
{
    [self.picker joinCategoriesWithCompletionHandler:^{
        [self.picker removeFromSuperview];
        [self.dismissMenuButton removeFromSuperview];
    }];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.blurredView.alpha = 0;
                     }
                     completion:^(BOOL success){
                         [self.blurredView removeFromSuperview];
                     }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void) insturmentCategoryTapped:(NSNotification *)notification
{
    [self stopMusic];
    [self presentViewController:[[self storyboard] instantiateViewControllerWithIdentifier:@"samplePickerNavigationController"]
                       animated:YES
                     completion:^{
                         [self removeMenu];
                     }];
}

- (void) showMenu
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.blurredView.image = [[self.view convertViewToImage] applyDarkEffect];
    
    self.blurredView.alpha = 0;
    
    [self.view addSubview:self.blurredView];
    
    [self.view addSubview:self.dismissMenuButton];
    
    [self.view addSubview:self.picker];
    
    [self.view bringSubviewToFront:self.picker];
    [self.picker splitCategories];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.blurredView.alpha = 1;
                     }];
}

- (IBAction)addSamplePressed:(UIButton *)sender
{
    [self showMenu];
}

@end
