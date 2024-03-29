//
//  TimeClock+Output.h
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
//  Copyright (C) 2010-2022, Franz Scholz <franz@franzscholz.net>, www.franzscholz.net
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


#import "TimeClock.h"

@interface TimeClock (Output)

#pragma mark Output

- (NSMutableString*) printProject:(Project *) project asHTMLtoMutableString:(NSMutableString*)output;
- (NSMutableString *)printProject:(Project *)project toMutableString:(NSMutableString *)mutableString;
- (NSMutableString *)printProjectWithName:(NSString *)name toMutableString:(NSMutableString *)mutableString;
- (BOOL)printProjectWithName:(NSString *)name toURL:(NSURL *)url error:(NSError **)error;

@end
