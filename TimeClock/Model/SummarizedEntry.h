//
//  SummarizedEntry.h
//  TimeClockAnalyzer
//
//  Created by Franz Scholz on 18.07.10.
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
