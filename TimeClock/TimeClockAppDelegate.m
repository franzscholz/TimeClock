//
//  TimeClockAppDelegate.m
//  TimeClock
//
//  Created by Franz Scholz on 24.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import "TimeClockAppDelegate.h"

#import "Entry.h"
#import "Entry+Extended.h"
#import "Project.h"
#import "Project+Extended.h"
#import "SummarizedEntry.h"

@implementation TimeClockAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize projectsArrayController;
@synthesize entriesArrayController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSError *error = nil;
    [self clearAll];
    [self readFromDefaultError:&error];
    if(error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        [[NSApplication sharedApplication] presentError:error];
    }
    
    for (Project *project in [self projects]) {
        NSLog(@"%@", project.description);
    }
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "net.franzscholz.TimeClock" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"net.franzscholz.TimeClock"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TimeClock" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"TimeClock.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        NSLog(@"%@", error.userInfo);
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

- (Entry*) newEntryWithProject:(Project*)p startDate:(NSDate*)date1 endDate:(NSDate*)date2 comment:(NSString*)aComment
{
    Entry* entry = [[Entry alloc] initWithEntity:[self.managedObjectModel.entitiesByName objectForKey: @"Entry"] insertIntoManagedObjectContext:self.managedObjectContext];
    entry.project = p;
	entry.start = date1;
	entry.end = date2;
	entry.comment = aComment;
	return entry;
}

- (Project *) newProjectWithName:(NSString *)name
{
    Project* project = [[Project alloc] initWithEntity:[self.managedObjectModel.entitiesByName objectForKey:@"Project"] insertIntoManagedObjectContext:self.managedObjectContext];
	project.name = name;
	return project;
}

- (void) clearAll
{
    for (Project *project in [self projects]) {
        [self.managedObjectContext deleteObject:project];
    }
}

#pragma mark Access

- (NSArray *) entries {
	// Retrieve the entries from the Store
	NSError *error;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext]];
	
	NSArray *entries = [self.managedObjectContext executeFetchRequest:request error:&error];
	if(entries == nil) {
		NSLog(@"Error: %@", error);
        [[NSApplication sharedApplication] presentError:error];
	}
	return entries;
}

- (NSArray *) projects {
	// Retrieve the projects from the Store
	NSError *error;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext]];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"finish" ascending:TRUE], nil];
    [request setSortDescriptors:sortDescriptors];
	
	NSArray *projects = [self.managedObjectContext executeFetchRequest:request error:&error];
	if(projects == nil) {
		NSLog(@"Error: %@", error);
        [[NSApplication sharedApplication] presentError:error];
	}
	return projects;
}

- (Project *) projectWithName:(NSString *)name
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project"
											  inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",
							  name];
	[fetchRequest setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		// Handle the error
		NSLog(@"Error: %@", [error localizedDescription]);
        [[NSApplication sharedApplication] presentError:error];
		return nil;
	}
	
	//NSLog(@"Fetched :\n%@", fetchedObjects);
	
	Project* project;
	if ([fetchedObjects count] == 0) {
		project = [self newProjectWithName:name];
	} else {
		project = [fetchedObjects objectAtIndex:0];
	}
	
	return project;
}


#pragma mark Analysis

- (NSArray*)collateEntriesByMonth
{
	// Accumulate the time for all the entries by year/month
	return [SummarizedEntry accumulateEntriesFromArray:[self entries] usingDateFormatter:[SummarizedEntry yearMonthFormatter]];
}

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
			lastEntry.end = date;
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


#pragma mark Output

- (NSMutableString*) printProjectAsHTML:(Project*)project toMutableString:(NSMutableString*)output
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


- (void)printOperationDidRun:(NSPrintOperation *)printOperation success:(BOOL)success contextInfo:(void *)contextInfo
{
    NSLog(@"%s: success = %@", __FUNCTION__, (success ? @"YES" : @"NO"));
}

- (void)printAction:(id)sender
{
    NSRect rect = NSMakeRect(0, 0, 468, 648);
    NSTextView *view = [[NSTextView alloc] initWithFrame:rect];
    NSMutableString *string = [[NSMutableString alloc] init];
    for (Project *project in projectsArrayController.selectedObjects) {
        [self printProjectAsHTML:project toMutableString:string];
    }
    NSLog(@"%@", string);
    NSLog(@"%@", entriesArrayController);
    NSDictionary * dict = [NSDictionary dictionary];
    NSAttributedString *contents = [[NSAttributedString alloc] initWithHTML:[string dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:&dict];
    [[view textStorage] setAttributedString:contents];
    
    NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
    NSPrintOperation *printOperation = [NSPrintOperation printOperationWithView:view printInfo:printInfo];
    [printOperation setCanSpawnSeparateThread:YES];
    [printOperation runOperationModalForWindow:self.window delegate:self didRunSelector:@selector(printOperationDidRun:success:contextInfo:) contextInfo:nil];
}



@end
