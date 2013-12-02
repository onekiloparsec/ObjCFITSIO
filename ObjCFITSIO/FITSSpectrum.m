//
//  FITSSpectrum.m
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 31/3/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "FITSSpectrum.h"
#import "FITSSpectrum+Private.h"

#import "FITSHeader.h"

@implementation FITSSpectrum

- (id)initWithHeader:(FITSHeader *)h dataPoints:(NSArray *)p
{
	self = [super init];
	if (self) {
		_points = p;
		NSString *s;
		s = [h stringValueForKey:@"CRVAL1"];
		_CRVAL1 = (s == nil) ? 0.0 : atof([s UTF8String]);
		s = [h stringValueForKey:@"CRPIX1"];
		_CRPIX1 = (s == nil) ? 0.0 : atof([s UTF8String]);
		s = [h stringValueForKey:@"CDELT1"];
		_CDELT1 = (s == nil) ? 0.0 : atof([s UTF8String]);
	}
	return self;
}

+ (FITSSpectrum *)spectrumWithHeader:(FITSHeader *)h dataPoints:(NSArray *)p
{
	return [[FITSSpectrum alloc] initWithHeader:h dataPoints:p];
}

- (NSUInteger)numberOfPoints
{
	return [_points count];
}

- (CGFloat)deltaXWithUnits:(FITSSpectrumXUnits)u
{
	return _CDELT1;
}

- (CGFloat)firstXValueWithUnits:(FITSSpectrumXUnits)u
{
	return (_CRVAL1 + _CDELT1 * (1 - _CRPIX1));
}

- (CGFloat)lastXValueWithUnits:(FITSSpectrumXUnits)u
{
	return (_CRVAL1 + _CDELT1 * ([self numberOfPoints] - _CRPIX1));
}

- (CGFloat)minimumYValueWithUnits:(FITSSpectrumYUnits)u
{
	NSArray *sortedPoints = [_points sortedArrayUsingSelector:@selector(compare:)];
	return [[sortedPoints objectAtIndex:0] doubleValue];
}

- (CGFloat)maximumYValueWithUnits:(FITSSpectrumYUnits)u
{
	NSArray *sortedPoints = [_points sortedArrayUsingSelector:@selector(compare:)];
	return [[sortedPoints lastObject] doubleValue];	
}

- (NSArray *)rawPoints
{
	return _points;
}

- (FITSSpectrumXUnits)rawXUnits
{
	return FITSSpectrumXUnitsRaw;
}

- (FITSSpectrumYUnits)rawYUnits
{
	return FITSSpectrumYUnitsRaw;	
}

- (NSArray *)pointsWithUnits:(FITSSpectrumYUnits)u
{
	return _points;
}

@end
