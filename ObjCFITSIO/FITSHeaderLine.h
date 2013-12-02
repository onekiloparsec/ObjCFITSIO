//
//  FITSHeaderLine.h
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import <Foundation/Foundation.h>

@interface FITSHeaderLine : NSObject 

@property(nonatomic, copy, readonly) NSString *key;
@property(nonatomic, copy, readonly) NSString *value;
@property(nonatomic, copy, readonly) NSString *comment;
@property(nonatomic, copy, readonly) NSString *rawLine;
@property(nonatomic, assign) BOOL showRaw;

+ (FITSHeaderLine *)headerLineWithKey:(NSString *)k value:(NSString *)v comment:(NSString *)c raw:(NSString *)r;

- (NSString *)whiteSpaceTrimmedKey;

@end
