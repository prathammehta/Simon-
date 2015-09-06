//
//  Singleton.h
//  Simon :)
//
//  Created by Pratham Mehta on 19/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TheAmazingAudioEngine.h"

@interface Singleton : NSObject

+ (Singleton *) sharedInstance;

+ (NSString *) getPackNameForNumber:(NSInteger)n;
+ (UIColor *) getColorForSample:(NSString *)name;

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) NSMutableArray *audioFilePlayers;

@property (nonatomic) NSInteger counterForPickerNames;
- (NSString *) getNameForPicker;


@end
