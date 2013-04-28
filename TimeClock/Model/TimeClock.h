//
//  TimeClock.h
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry;
@class Project;
@class SummarizedEntry;

@interface TimeClock : NSObject

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (TimeClock*) initWithManagedObjectModel:(NSManagedObjectModel *)model managedObjectContext:(NSManagedObjectContext *)context;

#pragma mark Management

- (void) clearAll;
- (Entry *) newEntryWithProject:(Project *) project startDate:(NSDate *)startDate endDate:(NSDate *)endDate comment:(NSString *)comment;
- (Project *) newProjectWithName:(NSString *)name;

#pragma mark Access

- (NSArray *) entries;
- (NSArray *) projects;
- (Project *) projectWithName: (NSString *)name;

#pragma mark Analysis

- (NSArray*)collateEntriesByMonth;

@end
