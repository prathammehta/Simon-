//
//  Sample+Operations.h
//  Simon :)
//
//  Created by Pratham Mehta on 22/01/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "Sample.h"
#import "Song.h"

@interface Sample (Operations)

+ (void) insertSampleWithName:(NSString *) name
                 withRedColor:(float) red
               withGreenColor:(float) green
                   withVolume:(float) volume
                       toSong:(Song *) song
                  withContext:(NSManagedObjectContext *)context;


@end
