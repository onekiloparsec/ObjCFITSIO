//
//  FITSHDU.m
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 6/1/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

#import "FITSHDU.h"
#import "FITSHDU+Private.h"

#import "FITSHeader.h"
#import "FITSHeader+Private.h"

#import "FITSImage.h"
#import "FITSImage+Private.h"

@implementation FITSHDU

@synthesize index;
@synthesize fitsFile;
@synthesize type;
@synthesize header;
@synthesize image;

- (id)initAtIndex:(NSUInteger)idx inFITSFile:(FITSFile *)fits
{
	NSAssert(fits, @"Fits file cannot be nil.");
	
	self = [super init];
	if (self) {
		fitsFile = fits;
		index = idx;
		type = FITSHDUTypeUndefined;
	}
	return self;
}

+ (FITSHDU *)HDUAtIndex:(NSUInteger)idx inFITSFile:(FITSFile *)fits
{
	return [[FITSHDU alloc] initAtIndex:idx inFITSFile:fits];
}

- (FITSHeader *)header
{
	return header;
}

- (FITSImage *)image
{
	return image;
}

@end
