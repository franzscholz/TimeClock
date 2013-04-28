//
//  Entry.h
//  TimeClock
//
//  Created by Franz Scholz on 25.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) Project *project;

@end
