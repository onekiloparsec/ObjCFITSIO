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

BOOL FITSIsEmptySize(FITSSize inputSize);
FITSSize FITSMakeSize(CGFloat nx, CGFloat ny, CGFloat nz);
FITSSize FITSMakeZeroSize(void);
NSString * NSStringFromFITSSize(FITSSize size);

typedef NS_ENUM(int, CFITSIO_STATUS) {
    CFITSIO_STATUS_OK = 0,
    CFITSIO_STATUS_SAME_FILE = 101, // input and output files are the same
    CFITSIO_STATUS_TOO_MANY_FILES = 103, // tried to open too many FITS files at once
    CFITSIO_STATUS_FILE_NOT_OPENED = 104, // could not open the named file
    CFITSIO_STATUS_FILE_NOT_CREATED = 105, // could not create the named file
    CFITSIO_STATUS_WRITE_ERROR = 106, // error writing to FITS file
    CFITSIO_STATUS_END_OF_FILE = 107, // tried to move past end of file
    CFITSIO_STATUS_READ_ERROR = 108, // error reading from FITS file
    CFITSIO_STATUS_FILE_NOT_CLOSED = 110, // could not close the file
    CFITSIO_STATUS_ARRAY_TOO_BIG = 111, // array dimensions exceed internal limit
    CFITSIO_STATUS_READONLY_FILE = 112, // Cannot write to readonly file
    CFITSIO_STATUS_MEMORY_ALLOCATION = 113, // Could not allocate memory
    CFITSIO_STATUS_BAD_FILEPTR = 114, // invalid fitsfile pointer
    CFITSIO_STATUS_NULL_INPUT_PTR = 115, // NULL input pointer to routine
    CFITSIO_STATUS_SEEK_ERROR = 116, // error seeking position in file
    
    CFITSIO_STATUS_BAD_URL_PREFIX = 121, // invalid URL prefix on file name
    CFITSIO_STATUS_TOO_MANY_DRIVERS = 122, // tried to register too many IO drivers
    CFITSIO_STATUS_DRIVER_INIT_FAILED = 123, // driver initialization failed
    CFITSIO_STATUS_NO_MATCHING_DRIVER = 124, // matching driver is not registered
    CFITSIO_STATUS_URL_PARSE_ERROR = 125, // failed to parse input file URL
    
    CFITSIO_STATUS_SHARED_BADARG = 151, // bad argument in shared memory driver
    CFITSIO_STATUS_SHARED_NULPTR = 152, // null pointer passed as an argument
    CFITSIO_STATUS_SHARED_TABFULL = 153, // no more free shared memory handles
    CFITSIO_STATUS_SHARED_NOTINIT = 154, // shared memory driver is not initialized
    CFITSIO_STATUS_SHARED_IPCERR = 155, // IPC error returned by a system call
    CFITSIO_STATUS_SHARED_NOMEM = 156, // no memory in shared memory driver
    CFITSIO_STATUS_SHARED_AGAIN = 157, // resource deadlock would occur
    CFITSIO_STATUS_SHARED_NOFILE = 158, // attempt to open/create lock file failed
    CFITSIO_STATUS_SHARED_NORESIZE = 159, // shared memory block cannot be resized at the moment
    
    CFITSIO_STATUS_HEADER_NOT_EMPTY = 201, // header already contains keywords
    CFITSIO_STATUS_KEY_NO_EXIST = 202, // keyword not found in header
    CFITSIO_STATUS_KEY_OUT_BOUNDS = 203, // keyword record number is out of bounds
    CFITSIO_STATUS_VALUE_UNDEFINED = 204, // keyword value field is blank
    CFITSIO_STATUS_NO_QUOTE = 205, // string is missing the closing quote
    
    CFITSIO_STATUS_BAD_KEYCHAR = 207, // illegal character in keyword name or card
    CFITSIO_STATUS_BAD_ORDER = 208, // required keywords out of order
    CFITSIO_STATUS_NOT_POS_INT = 209, // keyword value is not a positive integer
    CFITSIO_STATUS_NO_END = 210, // couldn't find END keyword
    CFITSIO_STATUS_BAD_BITPIX = 211, // illegal BITPIX keyword value
    CFITSIO_STATUS_BAD_NAXIS = 212, // illegal NAXIS keyword value
    CFITSIO_STATUS_BAD_NAXES = 213, // illegal NAXISn keyword value
    CFITSIO_STATUS_BAD_PCOUNT = 214, // illegal PCOUNT keyword value
    CFITSIO_STATUS_BAD_GCOUNT = 215, // illegal GCOUNT keyword value
    CFITSIO_STATUS_BAD_TFIELDS = 216, // illegal TFIELDS keyword value
    CFITSIO_STATUS_NEG_WIDTH = 217, // negative table row size
    CFITSIO_STATUS_NEG_ROWS = 218, // negative number of rows in table
    CFITSIO_STATUS_COL_NOT_FOUND = 219, // column with this name not found in table
    CFITSIO_STATUS_BAD_SIMPLE = 220, // illegal value of SIMPLE keyword
    CFITSIO_STATUS_NO_SIMPLE = 221, // Primary array doesn't start with SIMPLE
    CFITSIO_STATUS_NO_BITPIX = 222, // Second keyword not BITPIX
    CFITSIO_STATUS_NO_NAXIS = 223, // Third keyword not NAXIS
    CFITSIO_STATUS_NO_NAXES = 224, // Couldn't find all the NAXISn keywords
    CFITSIO_STATUS_NO_XTENSION = 225, // HDU doesn't start with XTENSION keyword
    CFITSIO_STATUS_NOT_ATABLE = 226, // the CHDU is not an ASCII table extension
    CFITSIO_STATUS_NOT_BTABLE = 227, // the CHDU is not a binary table extension
    CFITSIO_STATUS_NO_PCOUNT = 228, // couldn't find PCOUNT keyword
    CFITSIO_STATUS_NO_GCOUNT = 229, // couldn’t find GCOUNT keyword
    CFITSIO_STATUS_NO_TFIELDS = 230, // couldn't find TFIELDS keyword
    CFITSIO_STATUS_NO_TBCOL = 231, // couldn't find TBCOLn keyword
    CFITSIO_STATUS_NO_TFORM = 232, // couldn't find TFORMn keyword
    CFITSIO_STATUS_NOT_IMAGE = 233, // the CHDU is not an IMAGE extension
    CFITSIO_STATUS_BAD_TBCOL = 234, // TBCOLn keyword value < 0 or > rowlength
    CFITSIO_STATUS_NOT_TABLE = 235, // the CHDU is not a table
    CFITSIO_STATUS_COL_TOO_WIDE = 236, // column is too wide to fit in table
    CFITSIO_STATUS_COL_NOT_UNIQUE = 237, // more than 1 column name matches template
    CFITSIO_STATUS_BAD_ROW_WIDTH = 241, // sum of column widths not = NAXIS1
    
    CFITSIO_STATUS_UNKNOWN_EXT = 251, // unrecognizable FITS extension type
    CFITSIO_STATUS_UNKNOWN_REC = 252, // unknown record; 1st keyword not SIMPLE or XTENSION
    CFITSIO_STATUS_END_JUNK = 253, // END keyword is not blank
    CFITSIO_STATUS_BAD_HEADER_FILL = 254, // Header fill area contains non-blank chars
    CFITSIO_STATUS_BAD_DATA_FILL = 255, // Illegal data fill bytes (not zero or blank)
    CFITSIO_STATUS_BAD_TFORM = 261, // illegal TFORM format code
    CFITSIO_STATUS_BAD_TFORM_DTYPE = 262, // unrecognizable TFORM datatype code
    CFITSIO_STATUS_BAD_TDIM = 263, // illegal TDIMn keyword value
    CFITSIO_STATUS_BAD_HEAP_PTR = 264, // invalid BINTABLE heap pointer is out of range
    
    CFITSIO_STATUS_BAD_HDU_NUM = 301, // HDU number < 1 or > MAXHDU
    CFITSIO_STATUS_BAD_COL_NUM = 302, // column number < 1 or > tfields
    CFITSIO_STATUS_NEG_FILE_POS = 304, // tried to move to negative byte location in file
    
    CFITSIO_STATUS_NEG_BYTES = 306, // tried to read or write negative number of bytes
    CFITSIO_STATUS_BAD_ROW_NUM = 307, // illegal starting row number in table
    CFITSIO_STATUS_BAD_ELEM_NUM = 308, // illegal starting element number in vector
    CFITSIO_STATUS_NOT_ASCII_CO = 309, // this is not an ASCII string column
    CFITSIO_STATUS_NOT_LOGICAL_COL = 310, // this is not a logical datatype column
    CFITSIO_STATUS_BAD_ATABLE_FORMAT = 311, // ASCII table column has wrong format
    CFITSIO_STATUS_BAD_BTABLE_FORMAT = 312, // Binary table column has wrong format
    CFITSIO_STATUS_NO_NULL = 314, // null value has not been defined
    CFITSIO_STATUS_NOT_VARI_LEN = 317, // this is not a variable length column
    CFITSIO_STATUS_BAD_DIMEN = 320, // illegal number of dimensions in array
    CFITSIO_STATUS_BAD_PIX_NUM = 321, // first pixel number greater than last pixel
    CFITSIO_STATUS_ZERO_SCALE = 322, // illegal BSCALE or TSCALn keyword = 0
    CFITSIO_STATUS_NEG_AXIS = 323, // illegal axis length < 1
    
    CFITSIO_STATUS_NOT_GROUP_TABLE = 340, // Grouping function error
    CFITSIO_STATUS_HDU_ALREADY_MEMBER = 341,
    CFITSIO_STATUS_MEMBER_NOT_FOUND = 342,
    CFITSIO_STATUS_GROUP_NOT_FOUND = 343,
    CFITSIO_STATUS_BAD_GROUP_ID = 344,
    CFITSIO_STATUS_TOO_MANY_HDUS_TRACKED = 345,
    CFITSIO_STATUS_HDU_ALREADY_TRACKED = 346,
    CFITSIO_STATUS_BAD_OPTION = 347,
    CFITSIO_STATUS_IDENTICAL_POINTERS = 348,
    CFITSIO_STATUS_BAD_GROUP_ATTACH = 349,
    CFITSIO_STATUS_BAD_GROUP_DETACH = 350,
    CFITSIO_STATUS_NGP_NO_MEMORY = 360, // malloc failed
    CFITSIO_STATUS_NGP_READ_ERR = 361, // read error from file
    CFITSIO_STATUS_NGP_NUL_PTR = 362, // null pointer passed as an argument. Passing null pointer as a name of template file raises this error
    CFITSIO_STATUS_NGP_EMPTY_CURLINE = 363, // line read seems to be empty (used internally)
    CFITSIO_STATUS_NGP_UNREAD_QUEUE_FULL = 364, // cannot unread more then 1 line (or single line twice)
    CFITSIO_STATUS_NGP_INC_NESTING = 365, // too deep include file nesting (infinite loop, template includes itself ?)
    CFITSIO_STATUS_NGP_ERR_FOPEN = 366, // fopen() failed, cannot open template file
    CFITSIO_STATUS_NGP_EOF = 367, // end of file encountered and not expected
    CFITSIO_STATUS_NGP_BAD_ARG = 368, // bad arguments passed. Usually means internal parser error. Should not happen
    CFITSIO_STATUS_NGP_TOKEN_NOT_EXPECT = 369, // token not expected here
    
    CFITSIO_STATUS_BAD_I2C = 401, // bad int to formatted string conversion
    CFITSIO_STATUS_BAD_F2C = 402, // bad float to formatted string conversion
    
    CFITSIO_STATUS_BAD_DATE = 420, // error in date or time conversion
    
    CFITSIO_STATUS_PARSE_SYNTAX_ERR = 431, // syntax error in parser expression
    CFITSIO_STATUS_PARSE_BAD_TYPE = 432, // expression did not evaluate to desired type
    CFITSIO_STATUS_PARSE_LRG_VECTOR = 433, // vector result too large to return in array
    CFITSIO_STATUS_PARSE_NO_OUTPUT = 434, // data parser failed not sent an out column
    CFITSIO_STATUS_PARSE_BAD_COL = 435, // bad data encounter while parsing column
    CFITSIO_STATUS_PARSE_BAD_OUTPUT = 436, // Output file not of proper type
    
    CFITSIO_STATUS_ANGLE_TOO_BIG = 501, // celestial angle too large for projection
    CFITSIO_STATUS_BAD_WCS_VAL = 502, // bad celestial coordinate or pixel value
    CFITSIO_STATUS_WCS_ERROR = 503, // error in celestial coordinate calculation
    CFITSIO_STATUS_BAD_WCS_PROJ = 504, // unsupported type of celestial projection
    CFITSIO_STATUS_NO_WCS_KEY = 505, // celestial coordinate keywords not found
    CFITSIO_STATUS_APPROX_WCS_KEY = 506 // approximate wcs keyword values were returned
};

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
