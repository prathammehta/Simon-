//
//  Song+Operations.m
//  Simon :)
//
//  Created by Pratham Mehta on 22/01/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "Song+Operations.h"

@implementation Song (Operations)

+ (void) insertSongWithName:(NSString *) name
                withContext:(NSManagedObjectContext *) context
{
    Song *song = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:context];
    song.name = name;
    song.samples = nil;
}

@end
