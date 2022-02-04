//
//  Project+Extended.h
//  TimeClockAnalyzer
//
//  Created by Franz Scholz on 18.12.09.
//  Copyright (C) 2009-2022, Franz Scholz <franz@franzscholz.net>, www.franzscholz.net
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Project.h"

@interface Project (Extended)

- (NSDate*) startDate;
- (NSDate*) endDate;
- (NSNumber*) totalTime;

- (NSArray*) timesSummarizedByDate;

- (NSString *)description;

- (id)valueForUndefinedKey:(NSString *)key;

@end
