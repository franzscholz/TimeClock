//
//  TimeClock+Parser.h
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import "TimeClock.h"

@interface TimeClock (Parser)

#pragma mark Read from File

- (void)readFromString:(NSString *)string;
- (void)readFromURL: (NSURL *)url error:(NSError **)error;
- (void)readFromDefaultError:(NSError **)error;

@end
