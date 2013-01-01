//
//  FITSFile.h
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

@class FITSHDU;
@class FITSHeader;

@interface FITSFile : NSObject {
@private	
	NSURL *fileURL;
	FITSHDU *mainHDU;
}

+ (FITSFile *)FITSFileWithURL:(NSURL *)path;
+ (NSDictionary *)FITSFileShortSummaryWithURL:(NSURL *)path;
+ (FITSSize)fitsFile:(fitsfile *)fits HDUImageSizeAtIndex:(NSUInteger)index;

- (void)open;
- (void)close;

- (FITSHDU *)mainHDU;
- (NSArray *)HDUs;

- (NSInteger)countOfHDUs;
- (FITSHDUType)typeOfHDUAtIndex:(NSUInteger)index;

- (void)asyncLoadHeaderOfHDUAtIndex:(NSUInteger)index onCompletion:(dispatch_block_t)block;
- (void)asyncLoadImageOfHDUAtIndex:(NSUInteger)index onCompletion:(dispatch_block_t)block;

- (BOOL)syncLoadHeaderOfHDUAtIndex:(NSUInteger)index;
- (BOOL)syncLoadImageOfHDUAtIndex:(NSUInteger)index;

@end
