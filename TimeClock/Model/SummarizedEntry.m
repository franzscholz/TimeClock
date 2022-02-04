//
//  SummarizedEntry.m
//  TimeClockAnalyzer
//
//  Created by Franz Scholz on 18.07.10.
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


#import "SummarizedEntry.h"

#import "Entry.h"
#import "Entry+Extended.h"

static NSDateFormatter *yearMonthFormatter = nil;
static NSDateFormatter *yearMonthDayFormatter = nil;

@implementation SummarizedEntry

+ (NSDateFormatter*) yearMonthFormatter
{
	if(yearMonthFormatter == nil) {
		yearMonthFormatter = [[NSDateFormatter alloc] init];
		[yearMonthFormatter setDateFormat:@"YYYY-MM"];
	}
	
	return yearMonthFormatter;
}

+ (NSDateFormatter*) yearMonthDayFormatter
{
	if(yearMonthDayFormatter == nil) {
		yearMonthDayFormatter = [[NSDateFormatter alloc] init];
		[yearMonthDayFormatter setDateFormat:@"YYYY-MM-DD"];
	}
	return yearMonthDayFormatter;
}

- (SummarizedEntry*) init
{
	self = [super init];
	date = nil;
	label = [[NSMutableString alloc] init];
	hours = 0.0;
	return self;
}

- (NSDate*) date
{
	return date;
}

- (NSString*) label
{
	return label;
}

- (double) hours
{
	return hours;
}

- (void) appendEntry:(Entry *)entry
{
	if(date == nil) {
		date = entry.startDate;
	}
	hours += entry.duration.doubleValue;
	if([label length] > 0) {
		// Append the entry's comment but only if not already contained in the label
		NSRange range = [label rangeOfString:entry.comment];
		if(range.location == NSNotFound) {
			[label appendString:@", "];
			[label appendString:entry.comment];
		}
	} else {
		// No label yet: append the entry's comment
		[label appendString:entry.comment];
	}
}

- (NSString*) description;
{
	return [NSString stringWithFormat:@"%@ %.2f %@", self.date, self.hours, self.label];
}

#pragma mark Summarizing

+ (NSArray *) sortSummarizedEntryArray: (NSArray *) accumulated  {
	NSArray *result = [accumulated sortedArrayWithOptions:NSSortConcurrent usingComparator:^(id o1, id o2) {
		SummarizedEntry *e1 = (SummarizedEntry*)o1;
		SummarizedEntry *e2 = (SummarizedEntry*)o2;
        NSLog(@"%@ %@", [e1 description], [e2 description]);
		return [e1.date compare:e2.date];
	}];
	return result;
}

+ (void) summarizeEntry: (Entry *) entry dateFormatter: (NSDateFormatter *) dateFormatter dayEntries: (NSMutableDictionary *) dayEntries  {
		NSString *key = [dateFormatter stringFromDate:entry.startDate];
		if(key == nil) {
			NSLog(@"Key is nil for %@ and %@", dateFormatter, entry);
            return;
		}
		SummarizedEntry *summarizedEntry = [dayEntries objectForKey:key];
		
		// Create new entry if not existing yet
		if(summarizedEntry == nil) {
			summarizedEntry = [[SummarizedEntry alloc] init];
			[dayEntries setObject:summarizedEntry forKey:key];
		}
		
		// Add current data to the summarized entry
		[summarizedEntry appendEntry:entry];

}

+ (NSArray *) accumulateEntriesFromSet: (NSSet *) set usingDateFormatter: (NSDateFormatter *) dateFormatter  {
	__block NSMutableDictionary* dayEntries = [[NSMutableDictionary alloc] init];
	[set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		Entry *entry = (Entry*)obj;
		[self summarizeEntry: entry dateFormatter: dateFormatter dayEntries: dayEntries];
	}];
	// sort the result
	NSArray *accumulated = [dayEntries allValues];
	NSArray *result;
	result = [self sortSummarizedEntryArray: accumulated];
	
	return result;
}

+ (NSArray *) accumulateEntriesFromArray: (NSArray *)array usingDateFormatter: (NSDateFormatter *) dateFormatter  {
	__block NSMutableDictionary* dayEntries = [[NSMutableDictionary alloc] init];
	[array enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
		Entry *entry = (Entry*)obj;
		[self summarizeEntry: entry dateFormatter: dateFormatter dayEntries: dayEntries];
	}];
	// sort the result
	NSArray *accumulated = [dayEntries allValues];
	NSArray *result;
	result = [self sortSummarizedEntryArray: accumulated];
	
	return result;
}

@end
