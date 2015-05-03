//
//  Song+Operations.h
//  Simon :)
//
//  Created by Pratham Mehta on 22/01/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "Song.h"

@interface Song (Operations)

+ (void) insertSongWithName:(NSString *) name
                withContext:(NSManagedObjectContext *) context
              withImageData:(NSData *) data;

@end
