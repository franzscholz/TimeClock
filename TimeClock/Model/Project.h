//
//  Project.h
//  TimeClock
//
//  Created by Franz Scholz on 25.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * begin;
@property (nonatomic, retain) NSDate * finish;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) NSSet *entries;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
