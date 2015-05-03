//
//  Song.h
//  Simon
//
//  Created by Pratham Mehta on 24/04/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sample;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSDate * dateOfCreation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSSet *samples;
@end

@interface Song (CoreDataGeneratedAccessors)

- (void)addSamplesObject:(Sample *)value;
- (void)removeSamplesObject:(Sample *)value;
- (void)addSamples:(NSSet *)values;
- (void)removeSamples:(NSSet *)values;

@end
