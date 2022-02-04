//
//  TimeClockAppDelegate.h
//  TimeClock
//
//  Created by Franz Scholz on 24.04.13.
//  Copyright (C) 2010-2022, Franz Scholz <franz@franzscholz.net>, www.franzscholz.net
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
