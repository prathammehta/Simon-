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
        case 0: return @"Fonky";
            break;
        case 1: return @"HardRock";
            break;
        case 2: return @"RockPack";
            break;
        case 3: return @"Triphop";
            break;
        case 4: return @"HHCine";
            break;
        case 5: return @"JazzGrooTrans";
            break;
        case 6: return @"India";
            break;
        case 7: return @"Tekno";
            break;
        case 8: return @"CRoots";
            break;
        case 9: return @"MoonOrch";
            break;
    }
    return nil;
}

+ (UIColor *) getColorForSample:(NSString *)name
{
    
    if([name containsString:@"Fonky"])
    {
        return [UIColor colorWithRed:0.96 green:0.63 blue:0 alpha:1];
    }
    else if([name containsString:@"HardRock"])
    {
        return [UIColor colorWithRed:226.0/255.0 green:11/255.0 blue:5/255.0 alpha:1];
    }
    else if([name containsString:@"RockPack"])
    {
        return [UIColor colorWithRed:52/255.0 green:103/255.0 blue:122/255.0 alpha:1];
    }
    else if([name containsString:@"Triphop"])
    {
        return [UIColor colorWithRed:24/255.0 green:142/255.0 blue:54/255.0 alpha:1];
    }
    else if([name containsString:@"HHCine"])
    {
        return [UIColor colorWithRed:250/255.0 green:232/255.0 blue:5/255.0 alpha:1];
    }
    else if([name containsString:@"JazzGrooTrans"])
    {
        return [UIColor colorWithRed:0/255.0 green:102/255.0 blue:204/255.0 alpha:1];
    }
    else if([name containsString:@"India"])
    {
        return [UIColor colorWithRed:148/255.0 green:0/255.0 blue:212/255.0 alpha:1];
    }
    else if([name containsString:@"Tekno"])
    {
        return [UIColor colorWithRed:2/255.0 green:255/255.0 blue:2/255.0 alpha:1];
    }
    else if([name containsString:@"CRoots"])
    {
        return [UIColor colorWithRed:153/255.0 green:51/255.0 blue:0/255.0 alpha:1];
    }
    else if([name containsString:@"MoonOrch"])
    {
        return [UIColor colorWithRed:102/255.0 green:153/255.0 blue:255/255.0 alpha:1];
    }
    
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

@end
