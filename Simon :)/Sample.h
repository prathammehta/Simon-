//
//  Sample.h
//  Simon :)
//
//  Created by Pratham Mehta on 22/01/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Song;

@interface Sample : NSManagedObject

@property (nonatomic, retain) NSNumber * blueColor;
@property (nonatomic, retain) NSNumber * greenColor;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * redColor;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) Song *song;

@end
