//
//  Project.h
//  TimeClockAnalyzer
//
//  Created by Franz Scholz on 18.12.09.
//  Copyright 2009 Franz Scholz. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Project.h"

@interface Project (Extended)

- (NSDate*) begin;
- (NSDate*) finish;
- (NSNumber*) totalTime;

- (NSArray*) timesSummarizedByDate;

- (NSString *)description;

- (id)valueForUndefinedKey:(NSString *)key;

@end
