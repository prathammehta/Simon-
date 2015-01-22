//
//  Sample+Operations.m
//  Simon :)
//
//  Created by Pratham Mehta on 22/01/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "Sample+Operations.h"

@implementation Sample (Operations)

+ (void) insertSampleWithName:(NSString *) name
                 withRedColor:(float) red
               withGreenColor:(float) green
                   withVolume:(float) volume
                       toSong:(Song *) song
                  withContext:(NSManagedObjectContext *)context
{
    Sample *sample = [NSEntityDescription insertNewObjectForEntityForName:@"Sample"
                                                   inManagedObjectContext:context];
    sample.name = name;
    sample.song = song;
}

@end
