//
//  FITSHeader.m
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

#import "FITSHeader.h"
#import "FITSHeader+Private.h"
#import "FITSHeaderLine.h"
#import "FITSHDU.h"

@implementation FITSHeader

@synthesize loaded;
@synthesize HDUIndex;
@synthesize fitsHDU;

- (id)init
{
	self = [super init];
	if (self) {
		lines = [[NSMutableArray alloc] init];
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
	[lines addObject:headerLine];
}

- (NSUInteger)countOfLines
{
	return [lines count];
}

- (FITSHeaderLine *)lineAtIndex:(NSInteger)index
{
	return [lines objectAtIndex:index];
}

- (NSArray *)lines
{
	return [NSArray arrayWithArray:lines];
}

- (NSString *)stringValueForKey:(NSString *)key
{
	NSAssert(key, @"Key cannot be nil.");
	NSAssert([key length], @"Key cannot be empty.");

	__block NSString *answer = nil;
	NSArray *tmp = [NSArray arrayWithArray:lines];
	
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
