//
//  TimeClockAppDelegate.h
//  TimeClock
//
//  Created by Franz Scholz on 24.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Entry;
@class Project;

@interface TimeClockAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet NSArrayController *projectsArrayController;
@property (strong, nonatomic) IBOutlet NSArrayController *entriesArrayController;

- (IBAction)saveAction:(id)sender;
- (IBAction)printAction:(id)sender;

- (Entry*) newEntryWithProject:(Project*) project startDate:(NSDate*)startDate endDate:(NSDate*)endDate comment:(NSString*)comment;
- (Project*) newProjectWithName:(NSString *)name;

#pragma mark Read from File

- (void)readFromString:(NSString*)string;
- (void)readFromURL: (NSURL*)url error:(NSError**)error;
- (void)readFromDefaultError:(NSError**)error;

#pragma mark Output

- (NSMutableString*)printProject:(Project *)project toMutableString:(NSMutableString *)mutableString;
- (NSMutableString*)printProjectWithName:(NSString *)name toMutableString:(NSMutableString *)mutableString;
- (BOOL)printProjectWithName:(NSString*)name toURL:(NSURL*)url error:(NSError**)error;

#pragma mark Access

- (Project*)projectWithName: (NSString*)name;

#pragma mark Analysis

- (NSArray*)collateEntriesByMonth;


@end
