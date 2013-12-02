//
//  FITSImage.m
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 22/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "FITSImage.h"
#import "FITSImage+Private.h"
#import "FITSImage+Scaling.h"

#import "FITSHDU.h"
#import "FITSSpectrum.h"
#import "FITSSpectrum+Private.h"
#import "FITSConstants.h"

#import "DebugLog.h"

static NSInteger queueCount = 0;

@interface FITSImage () {
	dispatch_queue_t _processingQueue;
}
@end

@implementation FITSImage

- (id)initWithType:(FITSImageType)t size:(FITSSize)s
{	
	self = [super init];
	if (self) {
		_size = s;
		_type = t;
	}
	return self;
}

+ (FITSImage *)imageWithType:(FITSImageType)t size:(FITSSize)s
{
	return [[FITSImage alloc] initWithType:t size:s];
}

+ (FITSImage *)imageAtIndex:(NSUInteger)index fromHDU:(FITSHDU *)hdu withInfos:(FITSImageInfos)infos
{
	FITSImage *newImage = [[FITSImage alloc] initWithType:infos.bitpix size:infos.size];
	newImage.HDUIndex = index;
	newImage.fitsHDU = hdu;
	return newImage;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Image %@ %@", 
			[self humanSizeDescription], NSStringFromFITSSize(_size)];
}

- (BOOL)is1D
{
	BOOL condition1 = _size.nx != 0 && _size.ny == 0 && _size.nz == 0;
	BOOL condition2 = _size.nx == 0 && _size.ny != 0 && _size.nz == 0;
	BOOL condition3 = _size.nx == 0 && _size.ny == 0 && _size.nz != 0;
	return condition1 || condition2 || condition3;
}

- (BOOL)is2D
{
	BOOL condition1 = _size.nx != 0 && _size.ny != 0 && _size.nz == 0;
	BOOL condition2 = _size.nx != 0 && _size.ny == 0 && _size.nz != 0;
	BOOL condition3 = _size.nx == 0 && _size.ny != 0 && _size.nz != 0;
	return condition1 || condition2 || condition3;
}

- (long)numberOfPixels
{
    if ([self is1D]) {
        return (long)[self spectrumLength];
    }
    else if ([self is2D]) {
        return (long)_size.nx*_size.ny;
    }
    else {
        return NAN;
    }
}

- (FITSHeader *)header
{
	return self.fitsHDU.header;
}

- (NSString *)humanSizeDescription
{
	return ([self is2D]) ? @"2D" : (([self is1D]) ? @"1D" : @"?");
}

- (void)setImageData:(double *)rawImageData
{	
	if ([self is2D]) {
		[self set2DImageData:rawImageData];
	}
	else if ([self is1D]) {
		[self set1DImageData:rawImageData];
	}
}

- (void)set2DImageData:(double *)imageArray
{
	NSInteger width = (NSInteger)_size.nx;
	NSInteger height = (NSInteger)_size.ny;

	bitmapRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
														pixelsWide:width
														pixelsHigh:height
													 bitsPerSample:8
												   samplesPerPixel:1
														  hasAlpha:NO
														  isPlanar:NO
													colorSpaceName:NSCalibratedWhiteColorSpace
													   bytesPerRow:0
													  bitsPerPixel:8];

	NSDictionary *coefficients = [self zscaleCoefficientsForImage:imageArray];
	double z1 = [[coefficients objectForKey:@"z1"] doubleValue];
	double z2 = [[coefficients objectForKey:@"z2"] doubleValue];
		
	NSInteger rowBytes = [bitmapRep bytesPerRow];
	unsigned char *pix = [bitmapRep bitmapData];
	
	for (NSInteger i = 0; i < height; ++i) {
		for (NSInteger j = 0; j < width; ++j) {
			double v = imageArray[(height - i - 1) * width + j];
			if (v < z1) {
				v = 0.0;
			}
			else if (v > z2) {
				v = 255.0;
			}
			else {
				v = floor(255.0 * (v - z1) / (1.0 * (z2 - z1)));
			}
			pix[i * rowBytes + j] = (unsigned char)v;
//			pix[i * rowBytes + j] = (unsigned char)(imageArray[i * width + j]);
		}
	}
	
	if (bitmapRep) {
		image = [[NSImage alloc] initWithSize:NSMakeSize(_size.nx, _size.ny)];
		[image addRepresentation:bitmapRep];
		self.loaded = YES;
	}	
}

- (void)set1DImageData:(double *)rawImageData
{	
	CGFloat length = [self spectrumLength];

	NSMutableArray *points = [NSMutableArray arrayWithCapacity:length];
	for (int i = 0; i < length; i++) {
		NSNumber *point = [NSNumber numberWithDouble:rawImageData[i]];
		[points addObject:point];
	}

	FITSHeader *h = [[self fitsHDU] header];

	if (h && [points count] > 0) {
		spectrum = [FITSSpectrum spectrumWithHeader:h dataPoints:[NSArray arrayWithArray:points]];
		spectrum.originalImage = self;
		self.loaded = YES;
	}
}

- (void)setBitmapImageRep:(NSBitmapImageRep *)newRep
{
	spectrum = nil;
	bitmapRep = newRep;
	
	if (bitmapRep) {
		image = [[NSImage alloc] initWithSize:NSMakeSize(self.size.nx, self.size.ny)];
		[image addRepresentation:bitmapRep];
		self.loaded = YES;
	}
}

- (NSImage *)image
{
	return image;
}

- (CGImageRef)CGImage
{
	return [bitmapRep CGImage];
}

- (const unsigned char *)bitmapData
{
	return (const unsigned char *)[bitmapRep bitmapData];
}

- (NSImage *)imageScaledToSize:(NSSize)s
{
	NSAffineTransform *transform = [NSAffineTransform transform];
	CGFloat heightFactor = s.height/[image size].height;
	CGFloat widthFactor = s.width/[image size].width;
	CGFloat scale = (heightFactor > widthFactor) ? scale = widthFactor : heightFactor;
	[transform scaleBy:scale];
	
	NSImage *tmpImage = [[NSImage alloc] initWithCGImage:[self CGImage] size:image.size];
	[tmpImage setScalesWhenResized:YES];	
	
	NSImage *newImage = [[NSImage alloc] initWithSize:s];
	[newImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationLow];
	[tmpImage setSize:[transform transformSize:[tmpImage size]]];
	NSPoint p = NSMakePoint((s.width-tmpImage.size.width)/2.0, (s.height-tmpImage.size.height)/2.0);
	[tmpImage compositeToPoint:p operation:NSCompositeCopy];
	[newImage unlockFocus];
		
	return newImage;
}

- (CGImageRef)CGImageScaledToSize:(NSSize)s
{
	return [[self imageScaledToSize:s] CGImageForProposedRect:NULL 
													  context:[NSGraphicsContext currentContext]
														hints:nil];
}


- (NSColor *)colorAtPoint:(NSPoint)p
{
	return [bitmapRep colorAtX:p.x y:p.y];
}

- (CGFloat)normalizedIntensityAtPoint:(NSPoint)p
{
	if (p.x >= _size.nx || p.y >= _size.ny) {
		return NAN;
	}
	return [[bitmapRep colorAtX:p.x y:p.y] whiteComponent];
}

- (CGFloat)averageIntensityInRectWithCenter:(NSPoint)p width:(CGFloat)w
{
	if (p.x + w/2.0 >= _size.nx || p.y + w/2.0 > _size.ny) {
		return NAN;
	}
	
	CGFloat sum = 0;
	for (CGFloat x = p.x - w/2.0; x < p.x + w/2.0; x++) {
		for (CGFloat y = p.y - w/2.0; y < p.y + w/2.0; y++) {
			sum += [self normalizedIntensityAtPoint:NSMakePoint(x, y)];
		}
	}
	return sum/(w*w);
}

- (CGFloat)spectrumLength
{
	if (![self is1D]) {
		return NAN;
	}
	if (_size.nx > 0) {
		return _size.nx;
	}
	else if (_size.ny > 0) {
		return _size.ny;
	}
	else if (_size.nx > 0) {
		return _size.nz;
	}
	return NAN;
}

- (FITSSpectrum *)spectrum
{
	return spectrum;
}

- (void)applyZscalingOnProgress:(FITSImageScalingBlock_t)progressBlock onCompletion:(FITSImageBlock_t)completionBlock
{
	if (_processingQueue == nil) {
		NSString *name = [NSString stringWithFormat:@"com.onekiloparsec.ObjCFITSIO.FITSImage.processingQueue%ld", queueCount];
		_processingQueue = dispatch_queue_create([name UTF8String], DISPATCH_QUEUE_SERIAL);
		queueCount ++;
	}
	
	DebugLog(@"Applying zscaling...");
	dispatch_async(_processingQueue, ^{
		FITSImage *newImage = [self zscaledImage:^(double progress) {
			dispatch_async(dispatch_get_main_queue(), ^{
				progressBlock(progress);
			});
		}];
		dispatch_async(dispatch_get_main_queue(), ^{
			completionBlock(newImage);
		});
	});
}

@end
