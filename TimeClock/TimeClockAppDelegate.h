//
//  TimeClockAppDelegate.h
//  TimeClock
//
//  Created by Franz Scholz on 24.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TimeClockAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
