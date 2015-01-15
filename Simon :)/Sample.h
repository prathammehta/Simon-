//
//  Sample.h
//  Simon :)
//
//  Created by Pratham Mehta on 07/01/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sample : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) NSNumber * redColor;
@property (nonatomic, retain) NSNumber * greenColor;
@property (nonatomic, retain) NSNumber * blueColor;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSSet *songs;
@end

@interface Sample (CoreDataGeneratedAccessors)

- (void)addSongsObject:(NSManagedObject *)value;
- (void)removeSongsObject:(NSManagedObject *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
