//
//  FITSFile.m
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "FITSFile.h"

#import "FITSHDU.h"
#import "FITSHDU+Private.h"

#import "FITSHeader.h"
#import "FITSHeader+Private.h"

#import "FITSImage.h"
#import "FITSImage+Private.h"

#import "FITSConstants.h"

#import "DebugLog.h"

// This private iterface is kept here and not in a separate header, as it is relevant only here.

@interface FITSFile () {
    NSURL *_fileURL;
	fitsfile *_fits;
	CFITSIO_STATUS _status;
	BOOL _isOpen;
    FITSHDU *_mainHDU;
	NSMutableArray *_HDUs;
	
	// A queue allows to dispatch work on multiple threads. 
	// The fact that a fitsfile structure works on one specific HDU index at a time implies
	// that this queue must be serial, mandatorily. 
	dispatch_queue_t _serialQueue;
}
@end

@implementation FITSFile

+ (NSDictionary *)FITSFileShortSummaryWithURL:(NSURL *)URL
{
    FITSFile *fits = [FITSFile FITSFileWithURL:URL];
    NSDictionary *summary = [fits shortSummary];
    [fits close];
    return summary;
}

- (id)initWithURL:(NSURL *)URL
{
	NSAssert(URL, @"URL path cannot be nil");
	NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]],	@"FITS file must exists.");
	
	// check for correct FITS extension.
	
	self = [super init];
	if (self) {
		_fileURL = [URL copy];
        _status = 0; // Must be initialised, according to documentation.
		_isOpen = NO;
		_HDUs = [[NSMutableArray alloc] init];
		_serialQueue = dispatch_queue_create("com.onekiloparsec.ObjCFITSIO.FITSFile.serialQueue", DISPATCH_QUEUE_SERIAL);
	}
	return self;
}

+ (FITSFile *)FITSFileWithURL:(NSURL *)path
{
	return [[FITSFile alloc] initWithURL:path];
}

- (void)dealloc
{
	[self close];
}

- (CFITSIO_STATUS)open
{
	if (!_isOpen) {
		DebugLog(@"Opening FITS file at %@", [_fileURL path]);
        
        _status = CFITSIO_STATUS_OK; // Always put it to OK before using it, following documentation
        if ([_fileURL isFileURL]) {
            _status = OPEN_DISK_FILE; // This is crucial to avoid crazy parsing by cfitsio of the file path.
        }
        // Use 'path' and not 'absoluteString' to avoid parsing of 'file://'
        fits_open_file(&_fits, [[_fileURL path] fileSystemRepresentation], READONLY, &_status);
		
		if (_status > 0) {
			NSLog(@"Error status %d opening FITS file at path %@", _status, [_fileURL path]);
			return _status;
		}

		int HDUCount = 0;
        _status = CFITSIO_STATUS_OK;
		fits_get_num_hdus(_fits, &HDUCount, &_status);
		DebugLog(@"Number of HDUs: %d", HDUCount);
		
        _isOpen = YES;

		for (NSUInteger i = 0; i < HDUCount; i++) {
			FITSHDU *HDU = [FITSHDU HDUAtIndex:i inFITSFile:self];
			HDU.type = [self syncReadHDUTypeAtIndex:i];
			
			HDU.header = [FITSHeader headerAtIndex:i fromHDU:HDU];
			
			if (HDU.type == FITSHDUTypeImage) {
				FITSImageInfos infos = [self HDUImageInfosAtIndex:i];
				HDU.image = [FITSImage imageAtIndex:i fromHDU:HDU withInfos:infos];
			}
			
			[_HDUs addObject:HDU];
		}
	}
    
    return _status;
}

- (void)close
{
	if (_isOpen) {
        _status = CFITSIO_STATUS_OK;
        fits_close_file(_fits, &_status);
		_isOpen = NO;
	}
}

- (FITSHDU *)mainHDU;
{
	if (!_isOpen || [_HDUs count] == 0) {
		return nil;
	}
	return [_HDUs objectAtIndex:0];
}

- (FITSHDU *)HDUAtIndex:(NSUInteger)index;
{
	if (!_isOpen || index >= [_HDUs count]) {
		return nil;
	}
	return [_HDUs objectAtIndex:index];
}

- (NSArray *)HDUs
{
	return [NSArray arrayWithArray:_HDUs];
}

- (NSInteger)countOfHDUs
{
	if (!_isOpen) {
		return -1;
	}
	
	return (NSInteger)[_HDUs count];
}

- (FITSHDUType)typeOfHDUAtIndex:(NSUInteger)index
{
	if (!_isOpen) {
		return FITSHDUTypeUndefined;
	}
	
	NSAssert(index < [_HDUs count],
			 @"Index ouf bounds: index must be < %ld (is %ld)", 
			 index, [_HDUs count]);
	
	return (FITSHDUType)[(FITSHDU *)[_HDUs objectAtIndex:index] type];
}

- (NSDictionary *)shortSummary
{
    if (!_isOpen) {
        return nil;
    }
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *subtitles = [NSMutableArray array];
    
    int HDUCount = 0;
    fits_get_num_hdus(_fits, &HDUCount, &_status);
    
    int numImg = 0;
    
    for (int index = 0; index < HDUCount; index++) {
        fits_movabs_hdu(_fits, (int)index+1, NULL, &_status);
        int type = FITSHDUTypeUndefined;
        fits_get_hdu_type(_fits, &type, &_status);
        
        if (type == FITSHDUTypeImage) {
            FITSSize fitsSize = [FITSFile fitsFile:_fits HDUImageSizeAtIndex:index];
            if (!FITSIsEmptySize(fitsSize)) {
                [titles addObject:[NSString FITSHDUTypeString:type]];
                [subtitles addObject:NSStringFromFITSSize(fitsSize)];
                numImg ++;
            }
        }
    }
    
    NSMutableString *summary = [NSMutableString string];
    [summary appendFormat:@"%d HDU", HDUCount];
    if (HDUCount > 1) {
        [summary appendString:@"s"];
    }
    if (numImg > 0) {
        [summary appendString:@", "];
    }
    if (numImg == 1) {
        [summary appendString:@"1 image"];
    }
    else if (numImg > 1) {
        [summary appendFormat:@"%d images", numImg];
    }

    NSDictionary *FITSsummary = @{@"titles": titles, @"subtitles": subtitles, @"summary": summary};
    return FITSsummary;
}

#pragma mark - Header

- (BOOL)rawLoadHeaderAtIndex:(NSUInteger)index
{
	DebugLog(@"Loading FITS Header at index %lu...", index);

    [self rawMoveToHDUAtIndex:index];
		
	FITSHeader *header = [(FITSHDU *)[_HDUs objectAtIndex:index] header];
	
	int nkeys;
    _status = CFITSIO_STATUS_OK;
	fits_get_hdrspace(_fits, &nkeys, NULL, &_status);
	
	char card[FLEN_CARD];
	char key[FLEN_KEYWORD];
	char value[FLEN_VALUE];
	char comment[FLEN_COMMENT];
	
	for (int i = 0; i < nkeys; i++) {
		fits_read_record(_fits, i, card, &_status);
		
		NSMutableString *tmp = [NSMutableString stringWithUTF8String:card];
		CFStringTrimWhitespace((__bridge CFMutableStringRef)tmp);
		NSString *r = [NSString stringWithUTF8String:card];
		
		fits_read_keyn(_fits, i, key, value, comment, &_status);
		NSString *k = [NSString stringWithUTF8String:key];
		NSString *v = [NSString stringWithUTF8String:value];
		NSString *c = [NSString stringWithUTF8String:comment];
		
		if ([tmp length] > 0) {
			[header addKey:k value:v comment:c raw:r];
		}
	}	
	
	header.loaded = YES;
	
	return header.isLoaded;	
}

- (BOOL)syncLoadHeaderOfHDUAtIndex:(NSUInteger)index
{
	__block BOOL success = NO;
	
	dispatch_sync(_serialQueue, ^{
        success = [self rawLoadHeaderAtIndex:index];
	});
	
	return success;
}

- (void)asyncLoadHeaderOfHDUAtIndex:(NSUInteger)index onCompletion:(dispatch_block_t)block
{
	dispatch_async(_serialQueue, ^{
        [self rawLoadHeaderAtIndex:index];
		dispatch_async(dispatch_get_main_queue(), ^{
			block();
		});
	});    	
}

- (BOOL)syncLoadHeaderOfMainHDU
{
	return [self rawLoadHeaderAtIndex:0];
}

#pragma mark - Data

- (BOOL)rawLoadDataAtIndex:(NSUInteger)index
{	
	DebugLog(@"Loading FITS Image at index %lu...", index);
	
    [self rawMoveToHDUAtIndex:index];
	
    FITSImage *img = [(FITSHDU *)[_HDUs objectAtIndex:index] image];
    
    if (!img.isLoaded) {		
        long fpixel[] = {1, 1};        
        long numPixels = [img numberOfPixels];
        double *imageArray;
				
		imageArray = malloc(sizeof(double)*numPixels);		
		
        _status = CFITSIO_STATUS_OK;
		fits_read_pix(_fits, TDOUBLE, fpixel, numPixels, NULL, imageArray, NULL, &_status);
		
        BOOL success = (_status == 0);
        if (success) {
            [img setImageData:imageArray];
        }
		
		free(imageArray);
    }
	
	img.loaded = YES;
	
	return img.isLoaded;    
}

- (BOOL)syncLoadDataOfHDUAtIndex:(NSUInteger)index
{
	__block BOOL success = NO;
	
	dispatch_sync(_serialQueue, ^{
        success = [self rawLoadDataAtIndex:index];
	});
	
	return success;
}

- (void)asyncLoadDataOfHDUAtIndex:(NSUInteger)index onCompletion:(dispatch_block_t)block
{
	dispatch_async(_serialQueue, ^{
        [self rawLoadDataAtIndex:index];
		if (block) {
			dispatch_async(dispatch_get_main_queue(), ^{
				block();
			});
		}
	});
}


#pragma mark - Utils

- (FITSHDUType)syncReadHDUTypeAtIndex:(NSUInteger)index
{	
	__block int type = FITSHDUTypeUndefined;
	
	dispatch_sync(_serialQueue, ^{
        _status = CFITSIO_STATUS_OK;
		fits_movabs_hdu(_fits, (int)index+1, NULL, &_status);
		fits_get_hdu_type(_fits, &type, &_status);
	});
	
	return type;
}

- (void)rawMoveToHDUAtIndex:(NSUInteger)index
{	
    _status = CFITSIO_STATUS_OK;
	fits_movabs_hdu(_fits, (int)index+1, NULL, &_status);
}

+ (FITSSize)fitsFile:(fitsfile *)fits HDUImageSizeAtIndex:(NSUInteger)index
{
    CFITSIO_STATUS status = CFITSIO_STATUS_OK;
	fits_movabs_hdu(fits, (int)index+1, NULL, &status);

	FITSSize imgSize = FITSMakeZeroSize();

	int type = FITSHDUTypeUndefined;		
	fits_get_hdu_type(fits, &type, &status);

	if (type != FITSHDUTypeImage) {
		return imgSize;
	}
	
	int naxis;
	fits_get_img_dim(fits, &naxis, &status);
	
	if (status == 0) {
		int maxdim = naxis;
		long naxes[naxis];
		fits_get_img_size(fits, maxdim, naxes, &status);
		
		if (maxdim == 1) {
			imgSize = FITSMakeSize(naxes[0], 0, 0);
		}
		else if (maxdim == 2) {
			imgSize = FITSMakeSize(naxes[0], naxes[1], 0);
		}
	}		
	
	return imgSize;
}

- (FITSImageInfos)HDUImageInfosAtIndex:(NSUInteger)index
{ 
	DebugLog(@"Reading image basic infos at index %d", index);
 
	[self rawMoveToHDUAtIndex:index];
  
	__block FITSImageType imgBitpix = FITSImageTypeUndefined;
	__block FITSSize imgSize = FITSMakeZeroSize();
	
	dispatch_sync(_serialQueue, ^{
        _status = CFITSIO_STATUS_OK;
		fits_get_img_type(_fits, &imgBitpix, &_status);
		
		int naxis;
		fits_get_img_dim(_fits, &naxis, &_status);
 		
		if (_status == 0) {
			int maxdim = naxis;
			long naxes[naxis];
			fits_get_img_size(_fits, maxdim, naxes, &_status);
			
			if (maxdim == 1) {
				imgSize = FITSMakeSize(naxes[0], 0, 0);
			}
			else if (maxdim == 2) {
				imgSize = FITSMakeSize(naxes[0], naxes[1], 0);
			}
		}		
	});
 
	FITSImageInfos infos;
	infos.bitpix = imgBitpix;
	infos.size = imgSize;

	DebugLog(@"Found infos bitpix %d size %@", imgBitpix, NSStringFromFITSSize(imgSize));

	return infos;
}

@end
