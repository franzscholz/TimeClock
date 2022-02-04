//
//  TimeClock.h
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
//  Copyright (C) 2013-2022, Franz Scholz <franz@franzscholz.net>, www.franzscholz.net
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
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

/** Removes all the Projects from the context. */
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
