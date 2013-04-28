//
//  Project.m
//  TimeClock
//
//  Created by Franz Scholz on 18.12.09.
//  Copyright 2009 Franz Scholz. All rights reserved.
//

#import "Project.h"

#import "Entry.h"
#import "Entry+Extended.h"
#import "SummarizedEntry.h"
#import "TimeClockAppDelegate.h"

@implementation Project (Extended)

- (NSDate*) begin
{
    return [self valueForKeyPath:@"entries.@min.start"];
}

- (NSDate*) finish
{
    return [self valueForKeyPath:@"entries.@max.end"];
}

- (NSNumber*) totalTime
{
    return [self valueForKeyPath:@"entries.@sum.duration"];
}

- (NSArray*) timesSummarizedByDate
{
	return [SummarizedEntry accumulateEntriesFromSet:[self entries] usingDateFormatter:[SummarizedEntry yearMonthDayFormatter]];
}


- (NSString*) description
{
	return [NSString stringWithFormat:@"%@: total=%@ hours, %lu entries, %@ (%@ - %@)", self.name, [self valueForKeyPath:@"entries.@sum.duration"], (unsigned long)[self.entries count], [self timesSummarizedByDate], [self valueForKeyPath:@"entries.@min.start"], [self valueForKeyPath:@"entries.@max.end"]];
}


@end

