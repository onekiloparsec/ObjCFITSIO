//
//  FITSHDU_Private.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 14/3/12.
//  Copyright (c) 2012 onekiloparsec. All rights reserved.
//

/********************************
 PRIVATE INTERFACE
 Reserved to ObjCFITSIO Internals
 ********************************/

#import "FITSHDU.h"

@interface FITSHDU ()

@property(nonatomic, weak) FITSFile *fitsFile;
@property(nonatomic, assign) FITSHDUType type;

@property(nonatomic, strong) FITSHeader *header;
@property(nonatomic, strong) FITSImage *image;

@end
