//
//  FITSImage+Scaling.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 5/25/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import <Foundation/Foundation.h>
#import "FITSImage.h"

@interface FITSImage (Scaling)

- (NSDictionary *)zscaleCoefficientsForImage:(double *)imageArray;
- (FITSImage *)zscaledImage:(FITSImageScalingBlock_t)progressBlock;

@end
