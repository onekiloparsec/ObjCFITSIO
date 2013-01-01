//
//  FITSImage+Scaling.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 5/25/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

#import "FITSImage.h"

@interface FITSImage (Scaling)

- (NSDictionary *)zscaleCoefficientsForImage:(double *)imageArray;
- (FITSImage *)zscaledImage:(FITSImageScalingBlock_t)progressBlock;

@end
