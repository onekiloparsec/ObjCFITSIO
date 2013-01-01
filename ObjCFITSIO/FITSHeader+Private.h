//
//  FITSHeader_Private.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 3/14/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

/********************************
 PRIVATE INTERFACE
 Reserved to ObjCFITSIO Internals
 ********************************/

#import "FITSHeader.h"

@class FITSHDU;

@interface FITSHeader () {
@private	
	FITSHDU * __weak fitsHDU;
	NSUInteger HDUIndex;
}

@property(nonatomic, assign, getter=isLoaded) BOOL loaded;
@property(nonatomic, assign) NSUInteger HDUIndex;
@property(nonatomic, weak) FITSHDU *fitsHDU;

+ (FITSHeader *)headerAtIndex:(NSUInteger)index fromHDU:(FITSHDU *)hdu;

- (void)addKey:(NSString *)k value:(NSString *)v comment:(NSString *)c raw:(NSString *)r;

@end
