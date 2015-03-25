//
//  RecorderViewController.h
//  Simon
//
//  Created by Pratham Mehta on 24/03/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "Singleton.h"

@interface RecorderViewController : UIViewController

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AERecorder *recorder;

@end
