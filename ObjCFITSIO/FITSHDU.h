//
//  FITSHDU.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 6/1/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

#import "FITSFile.h"
#import "FITSHeader.h"
#import "FITSImage.h"

@interface FITSHDU : NSObject {
@private	
	FITSFile * __weak fitsFile;
	FITSHDUType type;
	NSUInteger index;
	
	FITSHeader *header;
	FITSImage *image;
}

@property(nonatomic, weak, readonly) FITSFile *fitsFile;
@property(nonatomic, assign, readonly) FITSHDUType type;
@property(nonatomic, assign, readonly) NSUInteger index;

+ (FITSHDU *)HDUAtIndex:(NSUInteger)idx inFITSFile:(FITSFile *)fits;

- (FITSHeader *)header;
- (FITSImage *)image;

@end
