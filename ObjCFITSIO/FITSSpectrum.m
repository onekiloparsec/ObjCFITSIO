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

@synthesize originalImage;

- (id)initWithHeader:(FITSHeader *)h dataPoints:(NSArray *)p
{
	self = [super init];
	if (self) {
		points = p;
		NSString *s;
		s = [h stringValueForKey:@"CRVAL1"];
		CRVAL1 = (s == nil) ? 0.0 : atof([s UTF8String]);
		s = [h stringValueForKey:@"CRPIX1"];
		CRPIX1 = (s == nil) ? 0.0 : atof([s UTF8String]);
		s = [h stringValueForKey:@"CDELT1"];
		CDELT1 = (s == nil) ? 0.0 : atof([s UTF8String]);
	}
	return self;
}

+ (FITSSpectrum *)spectrumWithHeader:(FITSHeader *)h dataPoints:(NSArray *)p
{
	return [[FITSSpectrum alloc] initWithHeader:h dataPoints:p];
}

- (NSUInteger)numberOfPoints
{
	return [points count];
}

- (CGFloat)deltaXWithUnits:(FITSSpectrumXUnits)u
{
	return CDELT1;
}

- (CGFloat)firstXValueWithUnits:(FITSSpectrumXUnits)u
{
	return (CRVAL1 + CDELT1 * (1 - CRPIX1));
}

- (CGFloat)lastXValueWithUnits:(FITSSpectrumXUnits)u
{
	return (CRVAL1 + CDELT1 * ([self numberOfPoints] - CRPIX1));	
}

- (CGFloat)minimumYValueWithUnits:(FITSSpectrumYUnits)u
{
	NSArray *sortedPoints = [points sortedArrayUsingSelector:@selector(compare:)];
	return [[sortedPoints objectAtIndex:0] doubleValue];
}

- (CGFloat)maximumYValueWithUnits:(FITSSpectrumYUnits)u
{
	NSArray *sortedPoints = [points sortedArrayUsingSelector:@selector(compare:)];
	return [[sortedPoints lastObject] doubleValue];	
}

- (NSArray *)rawPoints
{
	return points;
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
	return points;
}

@end
