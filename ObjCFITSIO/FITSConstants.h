//
//  FITSConstants.h
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 6/1/12.
//  Copyright (c) 2012 Soft Tenebras Lux. All rights reserved.
//

#import "fitsio.h"
#import <Foundation/Foundation.h>

typedef struct _FITSSize {
	CGFloat nx;
	CGFloat ny;
	CGFloat nz;	
} FITSSize;

FITSSize FITSMakeSize(CGFloat nx, CGFloat ny, CGFloat nz);
FITSSize FITSMakeZeroSize(void);
NSString * NSStringFromFITSSize(FITSSize size);

typedef enum _FITSImageType {
	FITSImageTypeByte		= BYTE_IMG,
	FITSImageTypeShort		= SHORT_IMG,
	FITSImageTypeLong		= LONG_IMG,
	FITSImageTypeLongLong	= LONGLONG_IMG,
	FITSImageTypeFloat		= FLOAT_IMG,
	FITSImageTypeDouble		= DOUBLE_IMG,
	FITSImageTypeUndefined	= 99
} FITSImageType;

typedef enum _FITSHDUType {
	FITSHDUTypeAny			= ANY_HDU,
	FITSHDUTypeImage		= IMAGE_HDU,
	FITSHDUTypeASCIITable	= ASCII_TBL,
	FITSHDUTypeBinaryTable	= BINARY_TBL,
	FITSHDUTypeUndefined	= 99
} FITSHDUType;

typedef enum _FITSDataType {
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
} FITSDataType;

typedef enum _FITSImageDataType {
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
} FITSImageDataType;

@interface NSString (FITSConstantsConversion)
+ (NSString *)FITSImageTypeString:(FITSImageType)t;
+ (NSString *)FITSHDUTypeString:(FITSHDUType)t;
@end
