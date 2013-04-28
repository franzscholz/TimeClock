//
//  SummarizedEntry.h
//  TimeClockAnalyzer
//
//  Created by Franz Scholz on 18.07.10.
//  Copyright 2010 Franz Scholz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Entry.h"


@interface SummarizedEntry : NSObject {
	NSDateFormatter *dayFormatter;
	NSDateFormatter *monthFormatter;

	NSDate *date;
	NSMutableString* label;
	double hours;
}

@property(readonly) NSDate* date;
@property(readonly) NSString* label;
@property(readonly) double hours;

+ (NSDateFormatter*) yearMonthFormatter;
+ (NSDateFormatter*) yearMonthDayFormatter;

- (SummarizedEntry*) init;

- (void) appendEntry:(Entry*)entry;

+ (NSArray*) sortSummarizedEntryArray:(NSArray*)array;
+ (NSArray*) accumulateEntriesFromSet:(NSSet*)set usingDateFormatter:(NSDateFormatter*)dateFormatter;
+ (NSArray*) accumulateEntriesFromArray:(NSArray*)array usingDateFormatter:(NSDateFormatter*)dateFormatter;

@end
