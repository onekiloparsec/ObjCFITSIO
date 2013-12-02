//
//  FITSSpectrum+Private.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 31/3/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

/********************************
 PRIVATE INTERFACE
 Reserved to ObjCFITSIO Internals
 ********************************/

#import <Foundation/Foundation.h>
#import "FITSSpectrum.h"

@class FITSHeader;

@interface FITSSpectrum () {
	NSArray *points;
	CGFloat CRVAL1;
	CGFloat CRPIX1;
	CGFloat CDELT1;
	FITSSpectrumXUnits rawXUnits;
	FITSSpectrumYUnits rawYUnits;
}

@property(nonatomic, weak) FITSImage *originalImage;

+ (FITSSpectrum *)spectrumWithHeader:(FITSHeader *)h dataPoints:(NSArray *)p;

@end
