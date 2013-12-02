//
//  FITSSpectrum.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 31/3/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import <Foundation/Foundation.h>

@class FITSImage;

typedef NS_ENUM(int, FITSSpectrumXUnits) {
	FITSSpectrumXUnitsRaw			= 0,
	FITSSpectrumXUnitsAngstroems	= 1,
	FITSSpectrumXUnitsMicrons		= 2,
	FITSSpectrumXUnitsNanometers	= 3
};

typedef NS_ENUM(int, FITSSpectrumYUnits) {
	FITSSpectrumYUnitsRaw	= 0,
	FITSSpectrumYUnitsADUs	= 1,
	FITSSpectrumYUnitsFlux	= 2,
};

@interface FITSSpectrum : NSObject 

@property(nonatomic, weak, readonly) FITSImage *originalImage;

- (NSUInteger)numberOfPoints;
- (CGFloat)deltaXWithUnits:(FITSSpectrumXUnits)u;

- (CGFloat)firstXValueWithUnits:(FITSSpectrumXUnits)u;
- (CGFloat)lastXValueWithUnits:(FITSSpectrumXUnits)u;

- (CGFloat)minimumYValueWithUnits:(FITSSpectrumYUnits)u;
- (CGFloat)maximumYValueWithUnits:(FITSSpectrumYUnits)u;

- (NSArray *)rawPoints;
- (FITSSpectrumXUnits)rawXUnits;
- (FITSSpectrumYUnits)rawYUnits;

- (NSArray *)pointsWithUnits:(FITSSpectrumYUnits)u;

@end
