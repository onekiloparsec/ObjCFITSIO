//
//  FITSConstants.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 6/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import <Foundation/Foundation.h>
#import "fitsio.h"

typedef struct {
	CGFloat nx;
	CGFloat ny;
	CGFloat nz;	
} FITSSize;

FITSSize FITSMakeSize(CGFloat nx, CGFloat ny, CGFloat nz);
FITSSize FITSMakeZeroSize(void);
NSString * NSStringFromFITSSize(FITSSize size);

typedef NS_ENUM(int, FITSImageType) {
	FITSImageTypeByte		= BYTE_IMG,
	FITSImageTypeShort		= SHORT_IMG,
	FITSImageTypeLong		= LONG_IMG,
	FITSImageTypeLongLong	= LONGLONG_IMG,
	FITSImageTypeFloat		= FLOAT_IMG,
	FITSImageTypeDouble		= DOUBLE_IMG,
	FITSImageTypeUndefined	= 99
};

typedef NS_ENUM(int, FITSHDUType) {
	FITSHDUTypeAny			= ANY_HDU,
	FITSHDUTypeImage		= IMAGE_HDU,
	FITSHDUTypeASCIITable	= ASCII_TBL,
	FITSHDUTypeBinaryTable	= BINARY_TBL,
	FITSHDUTypeUndefined	= 99
};

typedef NS_ENUM(int, FITSDataType) {
	FITSDataTypeBit				= TBIT,
	FITSDataTypeByte			= TBYTE,
	FITSDataTypeSignedByte		= TSBYTE,
	FITSDataTypeLogical			= TLOGICAL,
	FITSDataTypeString			= TSTRING,
	FITSDataTypeUnsignedShort	= TUSHORT,
	FITSDataTypeShort			= TSHORT,
	FITSDataTypeUnsignedInt		= TUINT,
	FITSDataTypeInt				= TINT,
	FITSDataTypeUnsignedLong	= TULONG,
	FITSDataTypeLong			= TLONG,
	FITSDataTypeInt32			= TINT32BIT,
	FITSDataTypeFloat			= TFLOAT,
	FITSDataTypeLongLong		= TLONGLONG,
	FITSDataTypeDouble			= TDOUBLE,
	FITSDataTypeComplex			= TCOMPLEX,
	FITSDataTypeDoubleComplex	= TDBLCOMPLEX
};

typedef NS_ENUM(int, FITSImageDataType) {
	FITSImageDataTypeByte			= FITSDataTypeByte,
	FITSImageDataTypeSignedByte		= FITSDataTypeSignedByte,
	FITSImageDataTypeShort			= FITSDataTypeShort,
	FITSImageDataTypeUnsignedShort	= FITSDataTypeUnsignedShort,
	FITSImageDataTypeInt			= FITSDataTypeInt,
	FITSImageDataTypeUnsignedInt	= FITSDataTypeUnsignedInt,
	FITSImageDataTypeLong			= FITSDataTypeLong,
	FITSImageDataTypeUnsignedLong	= FITSDataTypeUnsignedLong,
	FITSImageDataTypeFloat			= FITSDataTypeFloat,
	FITSImageDataTypeDouble			= FITSDataTypeDouble
};

@interface NSString (FITSConstantsConversion)
+ (NSString *)FITSImageTypeString:(FITSImageType)t;
+ (NSString *)FITSHDUTypeString:(FITSHDUType)t;
@end
