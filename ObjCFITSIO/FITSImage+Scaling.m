//
//  FITSImage+Scaling.m
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 5/25/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

// Translated from http://stsdas.stsci.edu/stsci_python_epydoc/numdisplay/numdisplay.zscale-pysrc.html#zscale
// See also http://stackoverflow.com/questions/5458770/nsimage-from-a-1d-pixel-array
// And https://wcs2kml.googlecode.com/svn-history/r25/trunk/python/fitsimage.py

#import "FITSImage+Scaling.h"
#import "FITSImage+Private.h"
#import "NSArray+NumericalOperations.h"

#import "DebugLog.h"

#define MAX_REJECT      0.5 
#define MIN_NPIXELS     5 
#define GOOD_PIXEL      0 
#define BAD_PIXEL       1 
#define KREJ            2.5 
#define MAX_ITERATIONS  5 

@implementation FITSImage (Scaling)

- (NSDictionary *)zscaleCoefficientsForImage:(double *)imageArray
{
    return [self applyZScaleWithNumberOfSamples:1000
									   contrast:0.25
								  badPixelsMask:0.0
										  zmask:nil
										 source:imageArray];
}

- (FITSImage *)zscaledImage:(FITSImageScalingBlock_t)progressBlock;
{
	NSDictionary *coeff = [self zscaleCoefficientsForImage:nil];
	if (coeff == nil) {
		return nil;
	}
	
	FITSImage *newImage = [FITSImage imageWithType:self.type size:self.size];
	
	[newImage setFitsHDU:self.fitsHDU];
	[newImage setHDUIndex:self.HDUIndex];
	
	NSUInteger z1 = [[coeff objectForKey:@"z1"] unsignedIntegerValue];
	NSUInteger z2 = [[coeff objectForKey:@"z2"] unsignedIntegerValue];
	
	NSAssert(z2 > z1, @"z2 <= z1 ???");
	DebugLog(@"Found zscale coefficients: z1 = %ld, z2 = %ld", z1, z2);
	
	NSBitmapImageRep *newBitmapRep = [bitmapRep copy];
	DebugLog(@"Applying zscale to image rep %@.", NSStringFromFITSSize(self.size));
	
	NSUInteger maxPixel = 255;
	
	NSUInteger pix;
	for (NSInteger i = 0; i < self.size.nx; i ++) {
		for (NSInteger j = 0; j < self.size.ny; j ++) {
			progressBlock((double)i/self.size.nx);
			
			[bitmapRep getPixel:&pix atX:i y:j];
			
			if (pix < z1) {
				[newBitmapRep setPixel:0 atX:i y:j];
			}
			else if (pix > z2) {
				[newBitmapRep setPixel:&maxPixel atX:i y:j];
			}
			else {
				NSUInteger value = (NSUInteger) floor(255.0 * (pix - z1) / (1.0 * (z2 - z1)));
				[newBitmapRep setPixel:&value atX:i y:j];
			}
		}
	}
	
	[newImage setBitmapImageRep:newBitmapRep];
	
	return newImage;
}


- (NSDictionary *)applyZScaleWithNumberOfSamples:(NSUInteger)nsamples
										contrast:(float)contrast
								   badPixelsMask:(double)bpmask
										   zmask:(id)zmask
										  source:(double *)imageArray
{
	DebugLog(@"Applying zscale algorithm on image with size %@: nsample: %ld, contrast: %.3f",
			 NSStringFromFITSSize(self.size), nsamples, contrast);
	
    NSArray *samples = [self zscaleSamples:nsamples source:imageArray];
    NSUInteger npix = [samples count];
	
    NSArray *sortedSamples = [samples sortedArrayUsingSelector:@selector(compare:)];
    
    double zmin = [[sortedSamples objectAtIndex:0] doubleValue];
	double zmax = [[sortedSamples lastObject] doubleValue];
    
    NSUInteger center_pixel = (NSUInteger)floor(npix - 1.0)/2.0;
    double median;
    if (npix%2 == 1) {
        median = [[sortedSamples objectAtIndex:center_pixel] doubleValue];
    }
    else {
		double v1 = [[sortedSamples objectAtIndex:center_pixel] doubleValue];
		double v2 = [[sortedSamples objectAtIndex:center_pixel+1] doubleValue];
        median = (v1 + v2)/2.0;
    }
	
    double minpix = MAX(MIN_NPIXELS, npix * MAX_REJECT);
    double ngrow = MAX(1.0, npix*0.01);
    
	NSDictionary *results = [self zscaleFitLineWithSamples:sortedSamples
													  krej:KREJ
													 ngrow:ngrow
												   maxiter:MAX_ITERATIONS];
	
	double ngoodpix = [[results objectForKey:@"ngoodpix"] doubleValue];
	double zslope   = [[results objectForKey:@"zslope"] doubleValue];
	
    double z1 = NAN;
    double z2 = NAN;
    if (ngoodpix < minpix) {
        z1 = zmin;
        z2 = zmax;
    }
    else {
        if (contrast > 0) { zslope = zslope / contrast; }
        z1 = MAX(zmin, median - (center_pixel - 1) * zslope);
        z2 = MIN(zmax, median + (npix - center_pixel) * zslope);
    }
	
	if (z1 == NAN || z2 == NAN) {
		return nil;
	}
	
	return @{@"z1":@(z1), @"z2":@(z2)};
}

- (NSArray *)zscaleSamples:(NSUInteger)maxpix source:(double *)imageArray
{
    double stride = MAX(1.0, sqrt((self.size.nx - 1.0) * (self.size.ny - 1.0) / (double)maxpix));
	DebugLog(@"Sampling image, maxpix: %ld, stride %.0f", maxpix, stride);

	NSUInteger pix;
	NSMutableArray *samples = [NSMutableArray array];
	
	for (NSInteger i = 0; i < self.size.nx; i += (NSInteger)floor(stride)) {
		for (NSInteger j = 0; j < self.size.ny; j += (NSInteger)floor(stride)) {
			if (imageArray == nil) {
				[bitmapRep getPixel:&pix atX:i y:j];
			}
			else {
				pix = (NSUInteger)floor(imageArray[j*(NSUInteger)self.size.nx+i]);
			}
			[samples addObject:@(pix)];
		}
	}

    return [samples subarrayWithRange:NSMakeRange(0, MAX(maxpix, [samples count]))];
}

- (NSDictionary *)zscaleFitLineWithSamples:(NSArray *)samples
                                      krej:(double)krej
                                     ngrow:(NSUInteger)ngrow
                                   maxiter:(NSUInteger)maxiter
{
	DebugLog(@"Fitting line in image, maxiter: %ld", maxiter);
	
	NSUInteger npix = [samples count];
    double xscale = 2.0 / (npix - 1.0);
	NSArray *xnorm = [NSArray arrayRangeFrom:0.0 to:npix slope:xscale zero:-1.0];
	
    NSUInteger ngoodpix = npix;
    NSUInteger minpix = MAX(MIN_NPIXELS, npix*MAX_REJECT);
    NSUInteger last_ngoodpix = npix + 1;
	
	DebugLog(@"Min pix %ld, last_ngoodpix: %ld", minpix, last_ngoodpix);
	
    // This is the mask used in k-sigma clipping.  0 is good, 1 is bad
    NSMutableArray *badpix = [[NSArray zeros:npix] mutableCopy];
	
	double intercept = 0.0;
	double slope = 0.0;
	
    for (NSUInteger niter = 0; niter < maxiter; niter++) {
        if ((ngoodpix >= last_ngoodpix) || (ngoodpix < minpix)) {
            break;
        }
		
		DebugLog(@"Starting iteration %ld", niter);
		
        NSIndexSet *goodPixelsIndexes = [badpix indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(NSNumber *pix, NSUInteger idx, BOOL *stop) {
            return [pix doubleValue] == GOOD_PIXEL;
        }];
		
		DebugLog(@"Number of good pixels %ld", [goodPixelsIndexes count]);
		
        double sumx  = [[xnorm objectsAtIndexes:goodPixelsIndexes] sum];
        double sumxx = [[xnorm objectsAtIndexes:goodPixelsIndexes] squaredSum];
        double sumxy = [[[xnorm objectsAtIndexes:goodPixelsIndexes] arrayByMultiplicatingValuesOfArray:[samples objectsAtIndexes:goodPixelsIndexes]] sum];
        double sumy  = [[samples objectsAtIndexes:goodPixelsIndexes] sum];
		double sum   = (double)[goodPixelsIndexes count];
		
		double delta = sum * sumxx - sumx * sumx;
		intercept = (sumxx * sumy - sumx * sumxy) / delta;
		slope = (sum * sumxy - sumx * sumy) / delta;
		
		// Subtract fitted line from the data array
		NSArray *fitted = [xnorm arrayByMultiplicatingValuesBy:slope andThenAdding:intercept];
        NSArray *flat = [samples arrayBySubstractingValuesOfArray:fitted];
        NSArray *goodFlat = [samples objectsAtIndexes:goodPixelsIndexes];
   		
		NSDictionary *results = [self zcaleComputeSigmaWithFlatPoints:goodFlat];
		ngoodpix = [[results objectForKey:@"ngoodpix"] doubleValue];
		double sigma = [[results objectForKey:@"sigma"] doubleValue];
		double threshold = sigma * krej;
		
		// Detect and reject pixels further than k*sigma from the fitted line
		double lcut = -threshold;
		double hcut = threshold;
		
		[flat enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSNumber *pix, NSUInteger idx, BOOL *stop) {
			double v = [pix doubleValue];
			if (v < lcut || v > hcut) {
				[badpix replaceObjectAtIndex:idx withObject:@(BAD_PIXEL)];
			}
		}];
		
		// Convolve with a kernel of length ngrow
		//        NSArray *kernel = [NSArray ones:ngrow];
		//		badpix = [[badpix arrayByConvolvingWithSameModeKernel:kernel] mutableCopy];
		//
		//        NSIndexSet *newGoodPixelsIndexes = [badpix indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(NSNumber *pix, NSUInteger idx, BOOL *stop) {
		//            return [pix doubleValue] == GOOD_PIXEL;
		//        }];
		//
		//		ngoodpix = [newGoodPixelsIndexes count];
		//
		//		DebugLog(@"New number of good pixels %ld", [newGoodPixelsIndexes count]);
    }
	
	// Transform the line coefficients back to the X range [0:npix-1]
	double zstart = intercept - slope;
	double zslope = slope * xscale;
	
	NSDictionary *parameters = @{@"ngoodpix" : @(ngoodpix), @"zslope":@(zslope), @"zstart":@(zstart)};
    return parameters;
}

- (NSDictionary *)zcaleComputeSigmaWithFlatPoints:(NSArray *)flat
{
    double sumz = [flat sum];
    double sumsq = [flat squaredSum];
	
    NSUInteger ngoodpix = [flat count];
    
    double mean = NAN;
    double sigma = NAN;
    
    if (ngoodpix == 1) {
        mean = sumz;
    }
    else if (ngoodpix > 1) {
        mean = sumz / ngoodpix;
        double temp = sumsq / (ngoodpix - 1) - sumz*sumz / (ngoodpix * (ngoodpix - 1));
        if (temp < 0) {
            sigma = 0.0 ;
        }
        else {
            sigma = sqrt(temp);
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithUnsignedInteger:ngoodpix], @"ngoodpix",
            [NSNumber numberWithDouble:mean], @"mean",
            [NSNumber numberWithDouble:sigma], @"sigma",
            nil];
}

@end
