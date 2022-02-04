//
//  TimeClockTests.m
//  TimeClockTests
//
//  Created by Franz Scholz on 04.02.22.
//  Copyright © 2022 Franz Scholz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TimeClock.h"
#import "TimeClock+Parser.h"
#import "Entry.h"

@interface TimeClockTests : XCTestCase {
    TimeClock *tc;
}
@end

@implementation TimeClockTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    
    NSManagedObjectModel* model;
    NSPersistentStoreCoordinator *coordinator;
    NSManagedObjectContext* context;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TimeClock" withExtension:@"momd"];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:coordinator];

    
    // Set-up code here.
    tc = [[TimeClock alloc] initWithManagedObjectModel:model managedObjectContext:context];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    tc = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testParseEntry
{
    Entry* entry = nil;
    entry = [tc parseLine:@"i 2014/12/01 13:30:00 ajkshdsjahds" fromLastEntry:entry];
    XCTAssertNotNil(entry, @"Parse failure");
    NSLog(@"%@", entry.description);
    entry = [tc parseLine:@"o 2014/12/01 15:00:00 ajkshdsjahds" fromLastEntry:entry];
    XCTAssertNotNil(entry, @"Parse failure");
    NSLog(@"%@", entry.description);
    XCTAssertEqualObjects(entry.duration, [NSNumber numberWithDouble:1.5], @"Duration is wrong");
}

- (void)testInvalidLine1
{
    Entry *entry = nil;
    entry = [tc parseLine:@"jasndkjsandksjn" fromLastEntry:entry];
    XCTAssertNil(entry, @"Expecting invalid entry");
}

- (void)testInvalidLine2
{
    Entry *entry = nil;
    entry = [tc parseLine:@"i 2014/12/01" fromLastEntry:entry];
    XCTAssertNil(entry, @"Expecting invalid entry");
}

- (void)testInvalidLine3
{
    Entry *entry = nil;
    entry = [tc parseLine:@"zzz 2014/12/01" fromLastEntry:entry];
    XCTAssertNil(entry, @"Expecting invalid entry");
}

- (void)testInvalidLine4
{
    Entry *entry = nil;
    entry = [tc parseLine:@"o 2014/12/01 12:15:00" fromLastEntry:entry];
    XCTAssertNil(entry, @"Expecting invalid entry");
}

- (void)testInvalidLine5 //* Not working, the time parser gives a valid date here
{
    Entry *entry = nil;
    entry = [tc parseLine:@"i 2014/12/01 27:15 [Project] klsajdlksajdklj salkdjklsajd" fromLastEntry:entry];
    XCTAssertNil(entry, @"Expecting invalid entry");
}

@end
