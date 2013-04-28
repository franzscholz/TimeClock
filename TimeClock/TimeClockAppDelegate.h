//
//  TimeClockAppDelegate.h
//  TimeClock
//
//  Created by Franz Scholz on 24.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TimeClock;

@interface TimeClockAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet NSArrayController *projectsArrayController;
@property (strong, nonatomic) IBOutlet NSArrayController *entriesArrayController;
@property (strong, nonatomic) TimeClock *timeClock;

- (IBAction)saveAction:(id)sender;
- (IBAction)printAction:(id)sender;


@end
