//
//  TimeClock+Parser.m
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
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


#import "TimeClock+Parser.h"

#import "Entry.h"

@implementation TimeClock (Parser)

#pragma mark Read from File

- (Entry *)parseLine:(NSString*)curLine fromLastEntry:(Entry*)lastEntry
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	NSArray *line = [curLine componentsSeparatedByString:@" "];
    
    // Check if there is enough input
	if([line count] < 3) {
		if([line count] > 0) {
			NSLog(@"Invalid line \"%@\"", curLine);
		}
        return nil;
    }

    // Clocking in or out
    NSString *inOut = [[line objectAtIndex:0] lowercaseString];
    if (![inOut hasPrefix:@"i"] && ![inOut hasPrefix:@"o"]) {
        NSLog(@"Invalid action %@ in line \"%@\"", inOut, curLine);
        return nil;
    }
    
    // Get the date
    NSString *dateString = [[line subarrayWithRange:NSMakeRange(1, 2)] componentsJoinedByString:@" "];
    NSDate* date = nil;
    NSError* error = nil;
    if(![dateFormatter getObjectValue:&date forString:dateString range:nil error:&error]) {
        NSLog(@"Invalid date %@ line \"%@\": %@", dateString, curLine, error.description);
        return nil;
        
    }

    NSLog(@"In/Out: \"%@\", Date: \"%@\"", inOut, [dateFormatter stringFromDate:date]);

    if([inOut hasPrefix:@"i"]) {
        // Clocking in
        NSDate *inDate;
        NSString *inProject;
        NSString *comment;
        inDate = date;
        NSRange range = NSMakeRange(3,[line count] - 3);
        inProject = [line objectAtIndex:range.location];
        if([inProject hasPrefix:@"["]) {
            range.location++;
            range.length--;
            if(range.length > 0) {
                comment = [[line subarrayWithRange:range] componentsJoinedByString:@" "];
            }
            else {
                comment = NSLocalizedString(@"n/a", @"Not available");
            }
            inProject = [inProject substringWithRange:NSMakeRange(1, [inProject length] - 1 - 1)];
        }
        else {
            inProject = NSLocalizedString(@"no Project", @"no project specified");
            comment = [[line subarrayWithRange:range] componentsJoinedByString:@" "];
        }
        Project *project = [self projectWithName:inProject];
        Entry *entry = [self newEntryWithProject:project startDate:inDate endDate:nil comment:comment];
        return entry;
    }
    else {
        // Clocking out
        lastEntry.endDate = date;
        return lastEntry;
    }	
}

- (void) readFromString: (NSString *) string  {
    __block Entry* lastEntry;
	[string enumerateLinesUsingBlock:^(NSString* line, BOOL *stop) {
		lastEntry = [self parseLine:line fromLastEntry:lastEntry];
	}];
}

- (BOOL)readFromURL:(NSURL *)url error:(NSError**)error
{
	NSLog(@"readFromURL:%@", url);
	NSString *logString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
	if(logString == nil) {
		return NO;
	}
    
	[self readFromString: logString];
    return YES;
}

- (BOOL)readFromDefaultError:(NSError**)error
{
	return [self readFromURL:[NSURL fileURLWithPath:[@"~/.timelog" stringByExpandingTildeInPath]] error:error];
}

@end
