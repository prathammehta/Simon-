//
//  Singleton.m
//  Simon :)
//
//  Created by Pratham Mehta on 19/12/14.
//  Copyright (c) 2014 Pratham Mehta. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

static Singleton *sharedInstance = nil;

+ (Singleton *) sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    return self;
}

- (NSMutableArray *) audioFilePlayers
{
    if(!_audioFilePlayers)
    {
        _audioFilePlayers = [[NSMutableArray alloc] init];
    }
    return _audioFilePlayers;
}

- (NSString *) getNameForPicker
{
    NSArray *names = @[@"Piano",@"Guitar",@"Drum",@"Trumpet",@"Sitar",@"Violin"];
    self.counterForPickerNames++;
    self.counterForPickerNames = self.counterForPickerNames % 6;
    return [names objectAtIndex:self.counterForPickerNames];
}

+ (id)allocWithZone:(NSZone*)zone
{
    return [self sharedInstance];
}

- (AEAudioController *) audioController
{
    if(!_audioController)
    {
        _audioController = [[AEAudioController alloc]
                            initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription]
                            inputEnabled:NO];
        NSError *error = NULL;
        BOOL result = [self.audioController start:&error];
        if(!result)
            NSLog(@"%@",error);
    }
    return _audioController;
}

+ (NSString *) getPackNameForNumber:(NSInteger)n
{
    switch(n)
    {
        case 0: return @"HardRock";
            break;
        case 1: return @"Fonky";
            break;
        case 2: return @"RockPack";
            break;
        case 3: return @"Triphop";
            break;
    }
    
    return nil;
}

@end
