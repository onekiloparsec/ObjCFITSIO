//
//  FITSHeader.m
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "FITSHeader.h"
#import "FITSHeader+Private.h"
#import "FITSHeaderLine.h"
#import "FITSHDU.h"

@implementation FITSHeader

- (id)init
{
	self = [super init];
	if (self) {
		_lines = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (FITSHeader *)emptyHeader
{
	FITSHeader *newHeader = [[FITSHeader alloc] init];
	return newHeader;
}

+ (FITSHeader *)headerAtIndex:(NSUInteger)index fromHDU:(FITSHDU *)hdu;
{
	FITSHeader *newHeader = [[FITSHeader alloc] init];
	newHeader.HDUIndex = index;
	newHeader.fitsHDU = hdu;
	return newHeader;
}

- (void)addKey:(NSString *)k value:(NSString *)v comment:(NSString *)c raw:(NSString *)r
{
	NSAssert(k, @"Key cannot be nil");
	FITSHeaderLine *headerLine = [FITSHeaderLine headerLineWithKey:k value:v comment:c raw:r];
	[_lines addObject:headerLine];
}

- (NSUInteger)countOfLines
{
	return [_lines count];
}

- (FITSHeaderLine *)lineAtIndex:(NSInteger)index
{
	return [_lines objectAtIndex:index];
}

- (NSArray *)lines
{
	return [NSArray arrayWithArray:_lines];
}

- (NSString *)stringValueForKey:(NSString *)key
{
	NSAssert(key, @"Key cannot be nil.");
	NSAssert([key length], @"Key cannot be empty.");

	__block NSString *answer = nil;
	NSArray *tmp = [NSArray arrayWithArray:_lines];
	
	[tmp enumerateObjectsUsingBlock:^(FITSHeaderLine *line, NSUInteger idx, BOOL *stop) {
		if ([[line whiteSpaceTrimmedKey] isEqualToString:key]) {
			answer = line.value;
			*stop = YES;
		}
	}];
	
	return answer;
}

- (double)doubleValueForKey:(NSString *)key
{
	NSAssert(key, @"Key cannot be nil.");
	NSAssert([key length], @"Key cannot be empty.");
	return [[self stringValueForKey:key] doubleValue];
}

@end
