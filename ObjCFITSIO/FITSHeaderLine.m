//
//  FITSHeaderLine.m
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

#import "FITSHeaderLine.h"


@implementation FITSHeaderLine

@synthesize key;
@synthesize value;
@synthesize comment;
@synthesize rawLine;
@synthesize showRaw;

- (id)initWithKey:(NSString *)k value:(NSString *)v comment:(NSString *)c raw:(NSString *)r
{
	self = [super init];
	if (self) {
		key = [k copy];
		value = [v copy];
		comment = [c copy];
		rawLine = [r copy];
	}
	return self;
}

+ (FITSHeaderLine *)headerLineWithKey:(NSString *)k value:(NSString *)v comment:(NSString *)c raw:(NSString *)r
{
	FITSHeaderLine *newLine = [[FITSHeaderLine alloc] initWithKey:k value:v comment:c raw:r];
	return newLine;
}

- (NSString *)whiteSpaceTrimmedKey
{
	if ([self.key length] == 0) {
		return nil;
	}
	CFMutableStringRef mutableKey = (__bridge_retained CFMutableStringRef)[self.key mutableCopy];
	CFStringTrimWhitespace(mutableKey);
	NSString *trimmedString = [NSString stringWithString:(__bridge NSString *)mutableKey];
	CFRelease(mutableKey);
	return trimmedString;
}

@end
