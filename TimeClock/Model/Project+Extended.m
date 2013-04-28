//
//  Project+Extended.m
//  TimeClock
//
//  Created by Franz Scholz on 18.12.09.
//  Copyright (C) 2009-2013, Franz Scholz <franz@franzscholz.net>, www.franzscholz.net
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

