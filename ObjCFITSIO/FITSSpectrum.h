//
//  FITSSpectrum.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 31/3/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

@class FITSImage;

typedef enum _FITSSpectrumXUnits {
	FITSSpectrumXUnitsRaw			= 0,
	FITSSpectrumXUnitsAngstroems	= 1,
	FITSSpectrumXUnitsMicrons		= 2,
	FITSSpectrumXUnitsNanometers	= 3
} FITSSpectrumXUnits;

typedef enum _FITSSpectrumYUnits {
	FITSSpectrumYUnitsRaw	= 0,
	FITSSpectrumYUnitsADUs	= 1,
	FITSSpectrumYUnitsFlux	= 2,
} FITSSpectrumYUnits;

@interface FITSSpectrum : NSObject {
@private	
	FITSImage * __weak originalImage;
}

@property(nonatomic, weak, readonly) FITSImage *originalImage;

- (NSUInteger)numberOfPoints;
- (CGFloat)deltaXWithUnits:(FITSSpectrumXUnits)u;

- (CGFloat)firstXValueWithUnits:(FITSSpectrumXUnits)u;
- (CGFloat)lastXValueWithUnits:(FITSSpectrumXUnits)u;

- (CGFloat)minimumYValueWithUnits:(FITSSpectrumXUnits)u;
- (CGFloat)maximumYValueWithUnits:(FITSSpectrumXUnits)u;

- (NSArray *)rawPoints;
- (FITSSpectrumXUnits)rawXUnits;
- (FITSSpectrumYUnits)rawYUnits;

- (NSArray *)pointsWithUnits:(FITSSpectrumYUnits)u;

@end
