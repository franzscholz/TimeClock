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

/** Central Storage.
 
    This is the central storage for the timeclock data.
 */
@interface TimeClock : NSObject

/** The NSManagedObjectModel. */
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
/** The NSManagedObjectContext. */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/** Initialize the storage.
 
    Initializes the storage with the object context and object model.
 
    @param model the NSManagedObjectModel.
    @param context the NSManagedObjectContext.
*/
- (TimeClock*) initWithManagedObjectModel:(NSManagedObjectModel *)model managedObjectContext:(NSManagedObjectContext *)context;

#pragma mark Management

/** Removes all the Projectss from the context. */
- (void) clearAll;
/** Creates a new Entry.
 
    Creates a new Entry with the supplied data.
 
    @param project the Project
    @param startDate the Entry's start date
    @param endDate the Entry's end date
    @param comment the Entry's comment
 */
- (Entry *) newEntryWithProject:(Project *) project startDate:(NSDate *)startDate endDate:(NSDate *)endDate comment:(NSString *)comment;
/** Creates a new Project.
 
    @param name the Project's name
 */
- (Project *) newProjectWithName:(NSString *)name;

#pragma mark Access

- (NSArray *) entries;
- (NSArray *) projects;
- (Project *) projectWithName: (NSString *)name;

#pragma mark Analysis

- (NSArray*)collateEntriesByMonth;

@end
