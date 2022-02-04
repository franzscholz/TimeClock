//
//  Entry+Extended.m
//  TimeClock
//
//  Created by Franz Scholz on 30.06.08.
//  Copyright (C) 2008-2022, Franz Scholz <franz@franzscholz.net>, www.franzscholz.net
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
	NSTimeInterval interval = [self.endDate timeIntervalSinceDate:self.startDate];
    [self didAccessValueForKey:@"start"];
    [self didAccessValueForKey:@"end"];
    return [NSNumber numberWithDouble:(interval / SECONDS_PER_HOUR)];
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%@: %@ %@ from %@ to %@", self.project.name, self.comment, self.duration, self.startDate, self.endDate];
}


@end
