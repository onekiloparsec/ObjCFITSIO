//
//  FITSConstants.m
//  ObjCFITSIO
//
//  Created by Cédric Foellmi on 6/1/12.
//  Released under GPLv2 by onekiloparsec (Cédric Foellmi)
//

#import "FITSConstants.h"

BOOL FITSIsEmptySize(FITSSize inputSize)
{
	return inputSize.nx == 0 && inputSize.ny == 0 && inputSize.nz == 0;
}

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
    NSMutableString *s = [NSMutableString stringWithString:@"["];
    if (size.nx || size.ny || size.nz) {
        [s appendFormat:@"%.0f", size.nx];
    }
    if (size.ny || size.nz) {
        if ([s length] > 1) {
            [s appendString:@":"];
        }
        [s appendFormat:@"%.0f", size.ny];
    }
    if (size.nz) {
        if ([s length] > 2) {
            [s appendString:@":"];
        }
        [s appendFormat:@"%.0f", size.nz];
    }
    [s appendString:@"]"];
	return [s copy];
}

NSString * NSStringFromCFITSIOStatus(CFITSIO_STATUS status)
{
    switch (status) {
            case CFITSIO_STATUS_OK: {
                return @"OK";
                break;
            }
            case CFITSIO_STATUS_SAME_FILE: {
                return @"input and output files are the same";
                break;
            }
            case CFITSIO_STATUS_TOO_MANY_FILES: {
                return @"tried to open too many FITS files at once";
                break;
            }
            case CFITSIO_STATUS_FILE_NOT_OPENED: {
                return @"could not open the named file";
                break;
            }
            case CFITSIO_STATUS_FILE_NOT_CREATED: {
                return @"could not create the named file";
                break;
            }
            case CFITSIO_STATUS_WRITE_ERROR: {
                return @"error writing to FITS file";
                break;
            }
            case CFITSIO_STATUS_END_OF_FILE: {
                return @"tried to move past end of file";
                break;
            }
            case CFITSIO_STATUS_READ_ERROR: {
                return @"error reading from FITS file";
                break;
            }
            case CFITSIO_STATUS_FILE_NOT_CLOSED: {
                return @"could not close the file";
                break;
            }
            case CFITSIO_STATUS_ARRAY_TOO_BIG: {
                return @"array dimensions exceed internal limit";
                break;
            }
            case CFITSIO_STATUS_READONLY_FILE: {
                return @"Cannot write to readonly file";
                break;
            }
            case CFITSIO_STATUS_MEMORY_ALLOCATION: {
                return @"Could not allocate memory";
                break;
            }
            case CFITSIO_STATUS_BAD_FILEPTR: {
                return @"invalid fitsfile pointer";
                break;
            }
            case CFITSIO_STATUS_NULL_INPUT_PTR: {
                return @"NULL input pointer to routine";
                break;
            }
            case CFITSIO_STATUS_SEEK_ERROR: {
                return @"error seeking position in file";
                break;
            }
            case CFITSIO_STATUS_BAD_URL_PREFIX: {
                return @"invalid URL prefix on file name";
                break;
            }
            case CFITSIO_STATUS_TOO_MANY_DRIVERS: {
                return @"tried to register too many IO drivers";
                break;
            }
            case CFITSIO_STATUS_DRIVER_INIT_FAILED: {
                return @"driver initialization failed";
                break;
            }
            case CFITSIO_STATUS_NO_MATCHING_DRIVER: {
                return @"matching driver is not registered";
                break;
            }
            case CFITSIO_STATUS_URL_PARSE_ERROR: {
                return @"failed to parse input file URL";
                break;
            }
            case CFITSIO_STATUS_SHARED_BADARG: {
                return @"bad argument in shared memory driver";
                break;
            }
            case CFITSIO_STATUS_SHARED_NULPTR: {
                return @"null pointer passed as an argument";
                break;
            }
            case CFITSIO_STATUS_SHARED_TABFULL: {
                return @"no more free shared memory handles";
                break;
            }
            case CFITSIO_STATUS_SHARED_NOTINIT: {
                return @"shared memory driver is not initialized";
                break;
            }
            case CFITSIO_STATUS_SHARED_IPCERR: {
                return @"IPC error returned by a system call";
                break;
            }
            case CFITSIO_STATUS_SHARED_NOMEM: {
                return @"no memory in shared memory driver";
                break;
            }
            case CFITSIO_STATUS_SHARED_AGAIN: {
                return @"resource deadlock would occur";
                break;
            }
            case CFITSIO_STATUS_SHARED_NOFILE: {
                return @"attempt to open/create lock file failed";
                break;
            }
            case CFITSIO_STATUS_SHARED_NORESIZE: {
                return @"shared memory block cannot be resized at the moment";
                break;
            }
            case CFITSIO_STATUS_HEADER_NOT_EMPTY: {
                return @"header already contains keywords";
                break;
            }
            case CFITSIO_STATUS_KEY_NO_EXIST: {
                return @"keyword not found in header";
                break;
            }
            case CFITSIO_STATUS_KEY_OUT_BOUNDS: {
                return @"keyword record number is out of bounds";
                break;
            }
            case CFITSIO_STATUS_VALUE_UNDEFINED: {
                return @"keyword value field is blank";
                break;
            }
            case CFITSIO_STATUS_NO_QUOTE: {
                return @"string is missing the closing quote";
                break;
            }
            case CFITSIO_STATUS_BAD_KEYCHAR: {
                return @"illegal character in keyword name or card";
                break;
            }
            case CFITSIO_STATUS_BAD_ORDER: {
                return @"required keywords out of order";
                break;
            }
            case CFITSIO_STATUS_NOT_POS_INT: {
                return @"keyword value is not a positive integer";
                break;
            }
            case CFITSIO_STATUS_NO_END: {
                return @"couldn't find END keyword";
                break;
            }
            case CFITSIO_STATUS_BAD_BITPIX: {
                return @"illegal BITPIX keyword value";
                break;
            }
            case CFITSIO_STATUS_BAD_NAXIS: {
                return @"illegal NAXIS keyword value";
                break;
            }
            case CFITSIO_STATUS_BAD_NAXES: {
                return @"illegal NAXISn keyword value";
                break;
            }
            case CFITSIO_STATUS_BAD_PCOUNT: {
                return @"illegal PCOUNT keyword value";
                break;
            }
            case CFITSIO_STATUS_BAD_GCOUNT: {
                return @"illegal GCOUNT keyword value";
                break;
            }
            case CFITSIO_STATUS_BAD_TFIELDS: {
                return @"illegal TFIELDS keyword value";
                break;
            }
            case CFITSIO_STATUS_NEG_WIDTH: {
                return @"negative table row size";
                break;
            }
            case CFITSIO_STATUS_NEG_ROWS: {
                return @"negative number of rows in table";
                break;
            }
            case CFITSIO_STATUS_COL_NOT_FOUND: {
                return @"column with this name not found in table";
                break;
            }
            case CFITSIO_STATUS_BAD_SIMPLE: {
                return @"illegal value of SIMPLE keyword";
                break;
            }
            case CFITSIO_STATUS_NO_SIMPLE: {
                return @"Primary array doesn't start with SIMPLE";
                break;
            }
            case CFITSIO_STATUS_NO_BITPIX: {
                return @"Second keyword not BITPIX";
                break;
            }
            case CFITSIO_STATUS_NO_NAXIS: {
                return @"Third keyword not NAXIS";
                break;
            }
            case CFITSIO_STATUS_NO_NAXES: {
                return @"Couldn't find all the NAXISn keywords";
                break;
            }
            case CFITSIO_STATUS_NO_XTENSION: {
                return @"HDU doesn't start with XTENSION keyword";
                break;
            }
            case CFITSIO_STATUS_NOT_ATABLE: {
                return @"the CHDU is not an ASCII table extension";
                break;
            }
            case CFITSIO_STATUS_NOT_BTABLE: {
                return @"the CHDU is not a binary table extension";
                break;
            }
            case CFITSIO_STATUS_NO_PCOUNT: {
                return @"couldn't find PCOUNT keyword";
                break;
            }
            case CFITSIO_STATUS_NO_GCOUNT: {
                return @"couldn’t find GCOUNT keyword";
                break;
            }
            case CFITSIO_STATUS_NO_TFIELDS: {
                return @"couldn't find TFIELDS keyword";
                break;
            }
            case CFITSIO_STATUS_NO_TBCOL: {
                return @"couldn't find TBCOLn keyword";
                break;
            }
            case CFITSIO_STATUS_NO_TFORM: {
                return @"couldn't find TFORMn keyword";
                break;
            }
            case CFITSIO_STATUS_NOT_IMAGE: {
                return @"the CHDU is not an IMAGE extension";
                break;
            }
            case CFITSIO_STATUS_BAD_TBCOL: {
                return @"TBCOLn keyword value < 0 or > rowlength";
                break;
            }
            case CFITSIO_STATUS_NOT_TABLE: {
                return @"the CHDU is not a table";
                break;
            }
            case CFITSIO_STATUS_COL_TOO_WIDE: {
                return @"column is too wide to fit in table";
                break;
            }
            case CFITSIO_STATUS_COL_NOT_UNIQUE: {
                return @"more than 1 column name matches template";
                break;
            }
            case CFITSIO_STATUS_BAD_ROW_WIDTH: {
                return @"sum of column widths not = NAXIS1";
                break;
            }
            case CFITSIO_STATUS_UNKNOWN_EXT: {
                return @"unrecognizable FITS extension type";
                break;
            }
            case CFITSIO_STATUS_UNKNOWN_REC: {
                return @"unknown record; 1st keyword not SIMPLE or XTENSION";
                break;
            }
            case CFITSIO_STATUS_END_JUNK: {
                return @"END keyword is not blank";
                break;
            }
            case CFITSIO_STATUS_BAD_HEADER_FILL: {
                return @"Header fill area contains non-blank chars";
                break;
            }
            case CFITSIO_STATUS_BAD_DATA_FILL: {
                return @"Illegal data fill bytes (not zero or blank)";
                break;
            }
            case CFITSIO_STATUS_BAD_TFORM: {
                return @"illegal TFORM format code";
                break;
            }
            case CFITSIO_STATUS_BAD_TFORM_DTYPE: {
                return @"unrecognizable TFORM datatype code";
                break;
            }
            case CFITSIO_STATUS_BAD_TDIM: {
                return @"illegal TDIMn keyword value";
                break;
            }
            case CFITSIO_STATUS_BAD_HEAP_PTR: {
                return @"invalid BINTABLE heap pointer is out of range";
                break;
            }
            case CFITSIO_STATUS_BAD_HDU_NUM: {
                return @"HDU number < 1 or > MAXHDU";
                break;
            }
            case CFITSIO_STATUS_BAD_COL_NUM: {
                return @"column number < 1 or > tfields";
                break;
            }
            case CFITSIO_STATUS_NEG_FILE_POS: {
                return @"tried to move to negative byte location in file";
                break;
            }
            case CFITSIO_STATUS_NEG_BYTES: {
                return @"tried to read or write negative number of bytes";
                break;
            }
            case CFITSIO_STATUS_BAD_ROW_NUM: {
                return @"illegal starting row number in table";
                break;
            }
            case CFITSIO_STATUS_BAD_ELEM_NUM: {
                return @"illegal starting element number in vector";
                break;
            }
            case CFITSIO_STATUS_NOT_ASCII_CO: {
                return @"this is not an ASCII string column";
                break;
            }
            case CFITSIO_STATUS_NOT_LOGICAL_COL: {
                return @"this is not a logical datatype column";
                break;
            }
            case CFITSIO_STATUS_BAD_ATABLE_FORMAT: {
                return @"ASCII table column has wrong format";
                break;
            }
            case CFITSIO_STATUS_BAD_BTABLE_FORMAT: {
                return @"Binary table column has wrong format";
                break;
            }
            case CFITSIO_STATUS_NO_NULL: {
                return @"null value has not been defined";
                break;
            }
            case CFITSIO_STATUS_NOT_VARI_LEN: {
                return @"this is not a variable length column";
                break;
            }
            case CFITSIO_STATUS_BAD_DIMEN: {
                return @"illegal number of dimensions in array";
                break;
            }
            case CFITSIO_STATUS_BAD_PIX_NUM: {
                return @"first pixel number greater than last pixel";
                break;
            }
            case CFITSIO_STATUS_ZERO_SCALE: {
                return @"illegal BSCALE or TSCALn keyword = 0";
                break;
            }
            case CFITSIO_STATUS_NEG_AXIS: {
                return @"illegal axis length < 1";
                break;
            }
            case CFITSIO_STATUS_NOT_GROUP_TABLE: {
                return @"Grouping function error";
                break;
            }
            case CFITSIO_STATUS_HDU_ALREADY_MEMBER: {
                return @"CFITSIO_STATUS_HDU_ALREADY_MEMBER";
                break;
            }
            case CFITSIO_STATUS_MEMBER_NOT_FOUND: {
                return @"CFITSIO_STATUS_MEMBER_NOT_FOUND";
                break;
            }
            case CFITSIO_STATUS_GROUP_NOT_FOUND: {
                return @"CFITSIO_STATUS_GROUP_NOT_FOUND";
                break;
            }
            case CFITSIO_STATUS_BAD_GROUP_ID: {
                return @"CFITSIO_STATUS_BAD_GROUP_ID";
                break;
            }
            case CFITSIO_STATUS_TOO_MANY_HDUS_TRACKED: {
                return @"CFITSIO_STATUS_TOO_MANY_HDUS_TRACKED";
                break;
            }
            case CFITSIO_STATUS_HDU_ALREADY_TRACKED: {
                return @"CFITSIO_STATUS_HDU_ALREADY_TRACKED";
                break;
            }
            case CFITSIO_STATUS_BAD_OPTION: {
                return @"CFITSIO_STATUS_BAD_OPTION";
                break;
            }
            case CFITSIO_STATUS_IDENTICAL_POINTERS: {
                return @"CFITSIO_STATUS_IDENTICAL_POINTERS";
                break;
            }
            case CFITSIO_STATUS_BAD_GROUP_ATTACH: {
                return @"CFITSIO_STATUS_BAD_GROUP_ATTACH";
                break;
            }
            case CFITSIO_STATUS_BAD_GROUP_DETACH: {
                return @"CFITSIO_STATUS_BAD_GROUP_DETACH";
                break;
            }
            case CFITSIO_STATUS_NGP_NO_MEMORY: {
                return @"malloc failed";
                break;
            }
            case CFITSIO_STATUS_NGP_READ_ERR: {
                return @"read error from file";
                break;
            }
            case CFITSIO_STATUS_NGP_NUL_PTR: {
                return @"null pointer passed as an argument. Passing null pointer as a name of template file raises this error";
                break;
            }
            case CFITSIO_STATUS_NGP_EMPTY_CURLINE: {
                return @"line read seems to be empty (used internally)";
                break;
            }
            case CFITSIO_STATUS_NGP_UNREAD_QUEUE_FULL: {
                return @"cannot unread more then 1 line (or single line twice)";
                break;
            }
            case CFITSIO_STATUS_NGP_INC_NESTING: {
                return @"too deep include file nesting (infinite loop, template includes itself ?)";
                break;
            }
            case CFITSIO_STATUS_NGP_ERR_FOPEN: {
                return @"fopen() failed, cannot open template file";
                break;
            }
            case CFITSIO_STATUS_NGP_EOF: {
                return @"end of file encountered and not expected";
                break;
            }
            case CFITSIO_STATUS_NGP_BAD_ARG: {
                return @"bad arguments passed. Usually means internal parser error. Should not happen";
                break;
            }
            case CFITSIO_STATUS_NGP_TOKEN_NOT_EXPECT: {
                return @"token not expected here";
                break;
            }
            case CFITSIO_STATUS_BAD_I2C: {
                return @"bad int to formatted string conversion";
                break;
            }
            case CFITSIO_STATUS_BAD_F2C: {
                return @"bad float to formatted string conversion";
                break;
            }
            case CFITSIO_STATUS_BAD_DATE: {
                return @"error in date or time conversion";
                break;
            }
            case CFITSIO_STATUS_PARSE_SYNTAX_ERR: {
                return @"syntax error in parser expression";
                break;
            }
            case CFITSIO_STATUS_PARSE_BAD_TYPE: {
                return @"expression did not evaluate to desired type";
                break;
            }
            case CFITSIO_STATUS_PARSE_LRG_VECTOR: {
                return @"vector result too large to return in array";
                break;
            }
            case CFITSIO_STATUS_PARSE_NO_OUTPUT: {
                return @"data parser failed not sent an out column";
                break;
            }
            case CFITSIO_STATUS_PARSE_BAD_COL: {
                return @"bad data encounter while parsing column";
                break;
            }
            case CFITSIO_STATUS_PARSE_BAD_OUTPUT: {
                return @"Output file not of proper type";
                break;
            }
            case CFITSIO_STATUS_ANGLE_TOO_BIG: {
                return @"celestial angle too large for projection";
                break;
            }
            case CFITSIO_STATUS_BAD_WCS_VAL: {
                return @"bad celestial coordinate or pixel value";
                break;
            }
            case CFITSIO_STATUS_WCS_ERROR: {
                return @"error in celestial coordinate calculation";
                break;
            }
            case CFITSIO_STATUS_BAD_WCS_PROJ: {
                return @"unsupported type of celestial projection";
                break;
            }
            case CFITSIO_STATUS_NO_WCS_KEY: {
                return @"celestial coordinate keywords not found";
                break;
            }
            case CFITSIO_STATUS_APPROX_WCS_KEY: {
                return @" approximate wcs keyword values were returned";
                break;
            }
        default: {
            return @"Undefined CFITSIO_STATUS value";
            break;
        }
    }
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
