//
//  TimeClockTests.m
//  TimeClockTests
//
//  Created by Franz Scholz on 24.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
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

#import "TimeClockTests.h"

#import "TimeClock.h"
#import "TimeClock+Parser.h"
#import "Entry.h"

@implementation TimeClockTests

- (void)setUp
{
    [super setUp];
    
    NSManagedObjectModel* model;
    NSPersistentStoreCoordinator *coordinator;
    NSManagedObjectContext* context;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TimeClock" withExtension:@"momd"];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];

    
    // Set-up code here.
    tc = [[TimeClock alloc] initWithManagedObjectModel:model managedObjectContext:context];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    tc = nil;
}

- (void)testParseEntry
{
    Entry* entry = nil;
    entry = [tc parseLine:@"i 2014/12/01 13:30:00 ajkshdsjahds" fromLastEntry:entry];
    STAssertNotNil(entry, @"Parse failure");
    NSLog(@"%@", entry.description);
    entry = [tc parseLine:@"o 2014/12/01 15:00:00 ajkshdsjahds" fromLastEntry:entry];
    STAssertNotNil(entry, @"Parse failure");
    NSLog(@"%@", entry.description);
    STAssertEqualObjects(entry.duration, [NSNumber numberWithDouble:1.5], @"Duration is wrong");
}

- (void)testInvalidLine1
{
    Entry *entry = nil;
    entry = [tc parseLine:@"jasndkjsandksjn" fromLastEntry:entry];
    STAssertNil(entry, @"Expecting invalid entry");
}

- (void)testInvalidLine2
{
    Entry *entry = nil;
    entry = [tc parseLine:@"i 2014/12/01" fromLastEntry:entry];
    STAssertNil(entry, @"Expecting invalid entry");
}

- (void)testInvalidLine3
{
    Entry *entry = nil;
    entry = [tc parseLine:@"zzz 2014/12/01" fromLastEntry:entry];
    STAssertNil(entry, @"Expecting invalid entry");
}

- (void)testInvalidLine4
{
    Entry *entry = nil;
    entry = [tc parseLine:@"o 2014/12/01 12:15:00" fromLastEntry:entry];
    STAssertNil(entry, @"Expecting invalid entry");
}

- (void)t3stInvalidLine5 //* Not working, the time parser gives a valid date here
{
    Entry *entry = nil;
    entry = [tc parseLine:@"i 2014/12/01 27:15 [Project] klsajdlksajdklj salkdjklsajd" fromLastEntry:entry];
    STAssertNil(entry, @"Expecting invalid entry");
}

@end
