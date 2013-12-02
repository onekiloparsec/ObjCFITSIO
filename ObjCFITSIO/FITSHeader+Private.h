//
//  FITSHeader_Private.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 3/14/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

/********************************
 PRIVATE INTERFACE
 Reserved to ObjCFITSIO Internals
 ********************************/

#import <Foundation/Foundation.h>
#import "FITSHeader.h"

@class FITSHDU;

@interface FITSHeader () 

@property(nonatomic, assign, getter=isLoaded) BOOL loaded;
@property(nonatomic, assign) NSUInteger HDUIndex;
@property(nonatomic, weak) FITSHDU *fitsHDU;

+ (FITSHeader *)headerAtIndex:(NSUInteger)index fromHDU:(FITSHDU *)hdu;

- (void)addKey:(NSString *)k value:(NSString *)v comment:(NSString *)c raw:(NSString *)r;

@end
