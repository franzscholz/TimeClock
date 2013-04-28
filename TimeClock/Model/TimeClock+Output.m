//
//  TimeClock+Output.m
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import "TimeClock+Output.h"

#import "Project.h"
#import "Project+Extended.h"
#import "Entry.h"
#import "Entry+Extended.h"
#import "SummarizedEntry.h"

@implementation TimeClock (Output)

#pragma mark Output

- (NSMutableString*) printProject:(Project *) project asHTMLtoMutableString:(NSMutableString*)output
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [output appendString:@"<HTML>\n"];
    [output appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>\n"];
    [output appendString:@"<BODY>\n"];
	NSString *formatString = NSLocalizedString(@"<h1>Project %@</h1>\n", @"HTML Project format");
	NSString *entryFormatString = NSLocalizedString(@"<p>%@<br/>%@ Hrs.</br>%@</p>\n", @"HTML Entry format");
	[output appendFormat:formatString, [project.name stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
	[[project timesSummarizedByDate] enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
		SummarizedEntry* cur = (SummarizedEntry*)obj;
		// TODO: Output of date only
		[output appendFormat:entryFormatString,
		 [dateFormatter stringFromDate:cur.date],
		 [numberFormatter stringFromNumber:[NSNumber numberWithDouble:cur.hours]],
		 cur.label];
	}];
	NSString *totalFormat = NSLocalizedString(@"<p>Total: %@ Hrs.</p>\n", @"HTML Format for project total");
	[output appendFormat:totalFormat,
	 [numberFormatter stringFromNumber:[project valueForKeyPath:@"entries.@sum.duration"]]];
    [output appendString:@"</BODY>\n"];
    [output appendString:@"</HTML>\n"];
    return output;
}

- (NSMutableString*) printProject:(Project*)project toMutableString:(NSMutableString*)output
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString *formatString = NSLocalizedString(@"\"Project\";\"%@\"\n", @"Project format");
	NSString *entryFormatString = NSLocalizedString(@"%@;%@;\"%@\"\n", @"Entry format");
	[output appendFormat:formatString, [project.name stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
	[[project timesSummarizedByDate] enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
		SummarizedEntry* cur = (SummarizedEntry*)obj;
		// TODO: Output of date only
		[output appendFormat:entryFormatString,
		 [dateFormatter stringFromDate:cur.date],
		 [numberFormatter stringFromNumber:[NSNumber numberWithDouble:cur.hours]],
		 cur.label];
	}];
	NSString *totalFormat = NSLocalizedString(@"\"Total\";%@\n", @"Format for project total");
	[output appendFormat:totalFormat,
	 [numberFormatter stringFromNumber:[project valueForKeyPath:@"entries.@sum.duration"]]];
    return output;
}

- (NSMutableString*) printProjectWithName:(NSString *)name toMutableString:(NSMutableString*)output
{
	return [self printProject:[self projectWithName:name] toMutableString:output];
}

- (BOOL) printProjectWithName:(NSString*)name toURL:(NSURL*)url error:(NSError **)error;
{
	NSMutableString *output = [[NSMutableString alloc] init];
	[self printProjectWithName:name toMutableString:output];
	
	BOOL ok = [output writeToURL:url atomically:NO encoding:NSUTF8StringEncoding error:error];
	
	return ok;
}
@end
