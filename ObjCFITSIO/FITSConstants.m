//
//  FITSConstants.m
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 6/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "FITSConstants.h"

FITSSize FITSMakeSize(CGFloat nx, CGFloat ny, CGFloat nz) 
{
    FITSSize s;
    s.nx = nx;
    s.ny = ny;
	s.nz = nz;
    return s;
}

FITSSize FITSMakeZeroSize() 
{
    FITSSize s;
    s.nx = 0;
    s.ny = 0;
	s.nz = 0;
    return s;
}

NSString * NSStringFromFITSSize(FITSSize size) 
{
	return [NSString stringWithFormat:@"[%.0f:%.0f:%.0f]", size.nx, size.ny, size.nz];
}


@implementation NSString (FITSConstantsConversion)

+ (NSString *)FITSImageTypeString:(FITSImageType)t
{
	switch (t) {
		case FITSImageTypeByte:
			return @"Byte";
			break;
		case FITSImageTypeShort:
			return @"Short";
			break;
		case FITSImageTypeLong:
			return @"Long";
			break;
		case FITSImageTypeLongLong:
			return @"Long Long";
			break;
		case FITSImageTypeFloat:
			return @"Float";
			break;
		case FITSImageTypeDouble:
			return @"Double";
			break;
		default:
			return @"(undefined)";
			break;
	}
}

+ (NSString *)FITSHDUTypeString:(FITSHDUType)t
{
	switch (t) {
		case FITSHDUTypeAny:
			return @"Any";
			break;
		case FITSHDUTypeASCIITable:
			return @"ASCII Table";
			break;
		case FITSHDUTypeBinaryTable:
			return @"Binary Table";
			break;
		case FITSHDUTypeImage:
			return @"Image";
			break;
		case FITSHDUTypeUndefined:
		default:
			return @"Undefined";
			break;	
	}
}

@end
