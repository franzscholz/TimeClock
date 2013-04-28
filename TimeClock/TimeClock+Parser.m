//
//  TimeClock+Parser.m
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import "TimeClock+Parser.h"

#import "Entry.h"

@implementation TimeClock (Parser)

#pragma mark Read from File

- (Entry *)parseLine:(NSString*)curLine fromLastEntry:(Entry*)lastEntry
{
	NSRange range;
	NSArray *line = [curLine componentsSeparatedByString:@" "];
	if([line count] >= 3) {
		NSString *inOut = [[line objectAtIndex:0] lowercaseString];
		range.location = 1;
		range.length = 2;
		NSString *dateString = [[line subarrayWithRange:range] componentsJoinedByString:@" "];
		NSDate *date = [NSDate dateWithNaturalLanguageString:dateString];
		NSLog(@"In/Out: \"%@\", Date: \"%@\"", inOut, [date description]);
		if([inOut hasPrefix:@"i"]) {
			NSDate *inDate;
			NSString *inProject;
			NSString *comment;
			// Clocking in
			inDate = date;
			range.location = 3;
			range.length = [line count] - range.location;
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
				range.location = 1;
				range.length = [inProject length] - range.location - 1;
				inProject = [inProject substringWithRange:range];
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
	else {
		if([line count] > 0) {
			NSLog(@"Invalid line \"%@\"", curLine);
		}
	}
	return nil;
	
}

- (void) readFromString: (NSString *) string  {
    __block Entry* lastEntry;
	[string enumerateLinesUsingBlock:^(NSString* line, BOOL *stop) {
		lastEntry = [self parseLine:line fromLastEntry:lastEntry];
	}];
}

- (void)readFromURL:(NSURL *)url error:(NSError**)error
{
	NSLog(@"readFromURL:%@", url);
	NSString *logString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
	if(logString == nil) {
		return;
	}
    
	[self readFromString: logString];
}

- (void)readFromDefaultError:(NSError**)error
{
	return [self readFromURL:[NSURL fileURLWithPath:[@"~/.timelog" stringByExpandingTildeInPath]] error:error];
}

@end
