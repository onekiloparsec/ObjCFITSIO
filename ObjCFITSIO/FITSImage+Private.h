//
//  FITSImage+Private.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 22/1/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

/********************************
 PRIVATE INTERFACE
 Reserved to ObjCFITSIO Internals
 ********************************/

@class FITSHDU;
@class FITSSpectrum;

typedef struct _FITSImageInfos {
	FITSImageType bitpix;
	FITSSize size;
} FITSImageInfos;


@interface FITSImage () {
@private	
	NSImage *image;
	NSBitmapImageRep *bitmapRep;
	FITSSpectrum *spectrum;
}

@property(nonatomic, assign, getter=isLoaded) BOOL loaded;
@property(nonatomic, assign) FITSImageType type;
@property(nonatomic, assign) NSUInteger HDUIndex;
@property(nonatomic, weak) FITSHDU *fitsHDU;

+ (FITSImage *)imageAtIndex:(NSUInteger)index fromHDU:(FITSHDU *)hdu withInfos:(FITSImageInfos)infos;
- (void)setBitmapImageRep:(NSBitmapImageRep *)newRep;

@end