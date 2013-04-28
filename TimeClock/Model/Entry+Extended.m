//
//  Entry.m
//  TimeClock
//
//  Created by Franz Scholz on 30.06.08.
//  Copyright 2008 franzscholz.net. All rights reserved.
//

#import "Entry+Extended.h"
#import "Project.h"

#define SECONDS_PER_HOUR (60.0*60.0)

@implementation Entry (Extended)

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setPrimitiveValue:[NSNumber numberWithDouble:0.0] forKey:@"duration"];
}

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    [self setPrimitiveValue:[NSNumber numberWithDouble:0.0] forKey:@"duration"];
}

- (NSSet*)keyPathsForAffectingDuration
{
    return [NSSet setWithObjects:@"start", @"end", nil];
}

- (NSNumber*) duration
{
    [self willAccessValueForKey:@"end"];
    [self willAccessValueForKey:@"start"];
	NSTimeInterval interval = [self.end timeIntervalSinceDate:self.start];
    [self didAccessValueForKey:@"start"];
    [self didAccessValueForKey:@"end"];
    return [NSNumber numberWithDouble:(interval / SECONDS_PER_HOUR)];
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%@: %@ %@ from %@ to %@", self.project.name, self.comment, self.duration, self.start, self.end];
}


@end
