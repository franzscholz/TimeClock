//
//  TimeClockEntry.h
//  TimeClockAnalyzer
//
//  Created by Franz Scholz on 30.06.08.
//  Copyright 2008 franzscholz.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Entry.h"

@interface Entry (Extended)

- (void)awakeFromInsert;
- (void)awakeFromFetch;

- (NSSet *)keyPathsForAffectingDuration;
- (NSNumber *)duration;

- (NSString *)description;

@end
