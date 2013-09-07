//
//  FITSHDU.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 6/1/12.
//  Copyright (c) 2012 onekiloparsec. All rights reserved.
//

#import "FITSConstants.h"

@class FITSFile;
@class FITSHeader;
@class FITSImage;

@interface FITSHDU : NSObject 

@property(nonatomic, weak, readonly) FITSFile *fitsFile;
@property(nonatomic, assign, readonly) FITSHDUType type;
@property(nonatomic, assign, readonly) NSUInteger index;

+ (FITSHDU *)HDUAtIndex:(NSUInteger)idx inFITSFile:(FITSFile *)fits;

- (FITSHeader *)header;
- (FITSImage *)image;

@end
