//
//  NSArray+NumericalOperations.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 5/25/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NumericalOperations)

+ (NSArray *)zeros:(NSUInteger)size;
+ (NSArray *)ones:(NSUInteger)size;
+ (NSArray *)arrayRangeFrom:(CGFloat)fromValue to:(CGFloat)toValue slope:(CGFloat)slopeValue zero:(CGFloat)zeroValue;

- (NSIndexSet *)indicesWhereValuesEqual:(double)v;
- (NSArray *)filteredArrayWhereValuesEqual:(double)v;
- (NSArray *)filteredArrayWhereValuesNotEqual:(double)v;
- (NSArray *)maskArrayFromArrayWhereValuesEqual:(double)v;

- (double)sum;
- (double)squaredSum;

- (NSArray *)arrayByAddingValuesOfArray:(NSArray *)secondArray;
- (NSArray *)arrayByMultiplicatingValuesOfArray:(NSArray *)secondArray;
- (NSArray *)arrayBySubstractingValuesOfArray:(NSArray *)secondArray;
- (NSArray *)arrayByMultiplicatingValuesBy:(CGFloat)multiply andThenAdding:(CGFloat)add;
- (NSArray *)arrayByConvolvingWithSameModeKernel:(NSArray *)kernel;

@end
