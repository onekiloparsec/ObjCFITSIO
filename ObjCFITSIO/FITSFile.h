//
//  FITSFile.h
//  Stif
//
//  Created by Cédric Foellmi on 1/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import <Foundation/Foundation.h>
#import "FITSConstants.h"

@class FITSHDU;
@class FITSHeader;

@interface FITSFile : NSObject 

+ (FITSFile *)FITSFileWithURL:(NSURL *)path;
+ (NSDictionary *)FITSFileShortSummaryWithURL:(NSURL *)path;
+ (FITSSize)fitsFile:(fitsfile *)fits HDUImageSizeAtIndex:(NSUInteger)index;

- (CFITSIO_STATUS)open;
- (void)close;

- (FITSHDU *)mainHDU;
- (FITSHDU *)HDUAtIndex:(NSUInteger)index;
- (NSArray *)HDUs;

- (NSInteger)countOfHDUs;
- (FITSHDUType)typeOfHDUAtIndex:(NSUInteger)index;

- (NSDictionary *)shortSummary;

- (void)asyncLoadHeaderOfHDUAtIndex:(NSUInteger)index onCompletion:(dispatch_block_t)block;
- (void)asyncLoadDataOfHDUAtIndex:(NSUInteger)index onCompletion:(dispatch_block_t)block;

- (BOOL)syncLoadHeaderOfHDUAtIndex:(NSUInteger)index;
- (BOOL)syncLoadDataOfHDUAtIndex:(NSUInteger)index;

- (BOOL)syncLoadHeaderOfMainHDU;

@end
