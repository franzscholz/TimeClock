//
//  TimeClock+Output.h
//  TimeClock
//
//  Created by Franz Scholz on 28.04.13.
//  Copyright (c) 2013 Franz Scholz. All rights reserved.
//

#import "TimeClock.h"

@interface TimeClock (Output)

#pragma mark Output

- (NSMutableString*) printProject:(Project *) project asHTMLtoMutableString:(NSMutableString*)output;
- (NSMutableString *)printProject:(Project *)project toMutableString:(NSMutableString *)mutableString;
- (NSMutableString *)printProjectWithName:(NSString *)name toMutableString:(NSMutableString *)mutableString;
- (BOOL)printProjectWithName:(NSString *)name toURL:(NSURL *)url error:(NSError **)error;

@end
