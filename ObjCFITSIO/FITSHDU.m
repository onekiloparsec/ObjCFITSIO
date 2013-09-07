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

- (id)initAtIndex:(NSUInteger)idx inFITSFile:(FITSFile *)fits
{
	NSAssert(fits, @"Fits file cannot be nil.");
	
	self = [super init];
	if (self) {
		_fitsFile = fits;
		_index = idx;
		_type = FITSHDUTypeUndefined;
	}
	return self;
}

+ (FITSHDU *)HDUAtIndex:(NSUInteger)idx inFITSFile:(FITSFile *)fits
{
	return [[FITSHDU alloc] initAtIndex:idx inFITSFile:fits];
}

- (FITSHeader *)header
{
	return _header;
}

- (FITSImage *)image
{
	return _image;
}

@end
