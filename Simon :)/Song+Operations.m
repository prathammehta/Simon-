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
              withImageData:(NSData *) data
{
    Song *song = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:context];
    song.name = name;
    song.dateOfCreation = [NSDate date];
    song.samples = nil;
    song.imageData = data;
}

@end
