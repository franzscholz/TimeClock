//
//  TimeClock.m
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
//  Copyright (C) 2010-2013, Franz Scholz <franz@franzscholz.net>, www.franzscholz.net
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


#import "TimeClock.h"

#import "Entry.h"
#import "Entry+Extended.h"
#import "Project.h"
#import "Project+Extended.h"
#import "SummarizedEntry.h"

@implementation TimeClock

@synthesize managedObjectModel;
@synthesize managedObjectContext;

- (TimeClock *)initWithManagedObjectModel:(NSManagedObjectModel *)model managedObjectContext:(NSManagedObjectContext *)context
{
    if((self = [super init]) != nil) {
        managedObjectContext = context;
        managedObjectModel = model;
    }
    return self;
}

#pragma mark Management

- (void) clearAll
{
    for (Project *project in [self projects]) {
        [self.managedObjectContext deleteObject:project];
    }
}

- (Entry*) newEntryWithProject:(Project*)p startDate:(NSDate*)date1 endDate:(NSDate*)date2 comment:(NSString*)aComment
{
    Entry* entry = [[Entry alloc] initWithEntity:[self.managedObjectModel.entitiesByName objectForKey: @"Entry"] insertIntoManagedObjectContext:self.managedObjectContext];
    entry.project = p;
	entry.startDate = date1;
	entry.endDate = date2;
	entry.comment = aComment;
	return entry;
}

- (Project *) newProjectWithName:(NSString *)name
{
    Project* project = [[Project alloc] initWithEntity:[self.managedObjectModel.entitiesByName objectForKey:@"Project"] insertIntoManagedObjectContext:self.managedObjectContext];
	project.name = name;
	return project;
}

#pragma mark Access

- (NSArray *) entries {
	// Retrieve the entries from the Store
	NSError *error;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext]];
	
	NSArray *entries = [self.managedObjectContext executeFetchRequest:request error:&error];
	if(entries == nil) {
		NSLog(@"Error: %@", error);
        [[NSApplication sharedApplication] presentError:error];
	}
	return entries;
}

- (NSArray *) projects {
	// Retrieve the projects from the Store
	NSError *error;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext]];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"finish" ascending:TRUE], nil];
    [request setSortDescriptors:sortDescriptors];
	
	NSArray *projects = [self.managedObjectContext executeFetchRequest:request error:&error];
	if(projects == nil) {
		NSLog(@"Error: %@", error);
        [[NSApplication sharedApplication] presentError:error];
	}
	return projects;
}

- (Project *) projectWithName:(NSString *)name
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project"
											  inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",
							  name];
	[fetchRequest setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		// Handle the error
		NSLog(@"Error: %@", [error localizedDescription]);
        [[NSApplication sharedApplication] presentError:error];
		return nil;
	}
	
	//NSLog(@"Fetched :\n%@", fetchedObjects);
	
	Project* project;
	if ([fetchedObjects count] == 0) {
		project = [self newProjectWithName:name];
	} else {
		project = [fetchedObjects objectAtIndex:0];
	}
	
	return project;
}


#pragma mark Analysis

- (NSArray*)collateEntriesByMonth
{
	// Accumulate the time for all the entries by year/month
	return [SummarizedEntry accumulateEntriesFromArray:[self entries] usingDateFormatter:[SummarizedEntry yearMonthFormatter]];
}

@end
