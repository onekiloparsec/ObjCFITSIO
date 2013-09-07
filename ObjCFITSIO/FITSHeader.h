//
//  FITSHeader.h
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Copyright (c) 2012 onekiloparsec. All rights reserved.
//

@class FITSHDU;
@class FITSHeader;
@class FITSHeaderLine;

@interface FITSHeader : NSObject {
@private	
	NSMutableArray *lines;
}

@property(nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;

+ (FITSHeader *)emptyHeader;

- (NSUInteger)countOfLines;
- (FITSHeaderLine *)lineAtIndex:(NSInteger)index;
- (NSArray *)lines;

- (NSString *)stringValueForKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key;

@end
