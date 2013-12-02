//
//  FITSHeaderLine.m
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "FITSHeaderLine.h"


@implementation FITSHeaderLine

- (id)initWithKey:(NSString *)k value:(NSString *)v comment:(NSString *)c raw:(NSString *)r
{
	self = [super init];
	if (self) {
		_key = [k copy];
		_value = [v copy];
		_comment = [c copy];
		_rawLine = [r copy];
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
