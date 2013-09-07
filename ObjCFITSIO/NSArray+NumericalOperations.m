//
//  NSArray+NumericalOperations.m
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 5/25/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "NSArray+NumericalOperations.h"

@implementation NSArray (NumericalOperations)

+ (NSArray *)zeros:(NSUInteger)size
{
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < size; i++) {
        [tmp addObject:[NSNumber numberWithDouble:0.0]];
    }
    return [NSArray arrayWithArray:tmp];
}

+ (NSArray *)ones:(NSUInteger)size
{
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < size; i++) {
        [tmp addObject:[NSNumber numberWithDouble:1.0]];
    }
    return [NSArray arrayWithArray:tmp];    
}

+ (NSArray *)arrayRangeFrom:(CGFloat)fromValue to:(CGFloat)toValue slope:(CGFloat)slopeValue zero:(CGFloat)zeroValue
{
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:(NSUInteger)floor(toValue-fromValue)];
    for (CGFloat i = fromValue; i < toValue; i++) {
        [tmp addObject:@(i*slopeValue+zeroValue)];
    }
    return [NSArray arrayWithArray:tmp];	
}

- (NSIndexSet *)indicesWhereValuesEqual:(double)v
{
    return [self indexesOfObjectsWithOptions:NSEnumerationConcurrent
                                 passingTest:^BOOL(NSNumber *element, NSUInteger idx, BOOL *stop) {
                                     return ([element doubleValue] == v);
                                 }];
}

- (NSArray *)filteredArrayWhereValuesEqual:(double)v
{
    return [self objectsAtIndexes:[self indicesWhereValuesEqual:v]];
}

- (NSArray *)maskArrayFromArrayWhereValuesEqual:(double)v
{
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(NSNumber *element, NSUInteger idx, BOOL *stop) {
        [tmp addObject:[NSNumber numberWithBool:([element doubleValue] == v)]];
    }];
    return [NSArray arrayWithArray:tmp];        
}

- (NSArray *)filteredArrayWhereValuesNotEqual:(double)v
{
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(NSNumber *element, NSUInteger idx, BOOL *stop) {
        [tmp addObject:[NSNumber numberWithBool:([element doubleValue] != v)]];
    }];
    return [NSArray arrayWithArray:tmp];	
}

- (double)sum
{
    __block double value = 0.0;
    [self enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        value += [num doubleValue];
    }];
    return value;
}

- (double)squaredSum
{
    __block double value = 0.0;
    [self enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        value += ([num doubleValue] * [num doubleValue]);
    }];
    return value;    
}

- (NSArray *)arrayByAddingValuesOfArray:(NSArray *)secondArray
{
    NSAssert([self count] == [secondArray count], @"Array sizes don't match.");
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSUInteger i = 0; i < [self count]; i++) {
        double value = [[self objectAtIndex:i] doubleValue] + [[secondArray objectAtIndex:i] doubleValue];
        [resultArray addObject:[NSNumber numberWithDouble:value]];
    }
    
    return [NSArray arrayWithArray:resultArray];
}

- (NSArray *)arrayBySubstractingValuesOfArray:(NSArray *)secondArray
{
    NSAssert([self count] == [secondArray count], @"Array sizes don't match.");
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSUInteger i = 0; i < [self count]; i++) {
        double value = [[self objectAtIndex:i] doubleValue] - [[secondArray objectAtIndex:i] doubleValue];
        [resultArray addObject:[NSNumber numberWithDouble:value]];
    }
    
    return [NSArray arrayWithArray:resultArray];
}

- (NSArray *)arrayByMultiplicatingValuesOfArray:(NSArray *)secondArray
{
    NSAssert([self count] == [secondArray count], @"Array sizes don't match.");
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSUInteger i = 0; i < [self count]; i++) {
        double value = [[self objectAtIndex:i] doubleValue] + [[secondArray objectAtIndex:i] doubleValue];
        [resultArray addObject:[NSNumber numberWithDouble:value]];
    }
    
    return [NSArray arrayWithArray:resultArray];
}

- (NSArray *)arrayByMultiplicatingValuesBy:(CGFloat)multiply andThenAdding:(CGFloat)add
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSUInteger i = 0; i < [self count]; i++) {
        double value = [[self objectAtIndex:i] doubleValue] * multiply + add;
        [resultArray addObject:[NSNumber numberWithDouble:value]];
    }
    
    return [NSArray arrayWithArray:resultArray];	
}

- (NSArray *)arrayByConvolvingWithSameModeKernel:(NSArray *)kernel
{
	NSAssert(kernel, @"Kernel cannot be nil.");
	NSAssert([kernel count] > 0, @"Kernel cannot be empty.");
	
	NSUInteger count = [self count];
	NSUInteger halfWidth = (NSUInteger)floor([kernel count]/2.0);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:count];
	
    for (NSInteger i = 0; i < [self count]; i++) {
		double value = [[self objectAtIndex:i] doubleValue];
		for (NSInteger j = -halfWidth; j < halfWidth; j++) {
			if (i+j >= 0 && i+j <= count) {
				value += [[self objectAtIndex:i+j] doubleValue]*[[kernel objectAtIndex:j+halfWidth] doubleValue];
			}
		}
        [resultArray addObject:@(value)];
    }
    
    return [NSArray arrayWithArray:resultArray];
}

@end
