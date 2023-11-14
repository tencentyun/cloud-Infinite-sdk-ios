#ifndef IMAGEUTIL_H
#define IMAGEUTIL_H
#include <vector>



// APNG decode
struct APNGFrame { unsigned char * p, ** rows; unsigned int w, h, delay_num, delay_den; };
typedef struct { unsigned char r, g, b; } rgb;
typedef struct { unsigned char * p, ** rows, t; unsigned int w, h; int ps, ts; rgb pl[256]; unsigned char tr[256]; int num, den; } image_info;
int load_apng(char * szIn, std::vector<APNGFrame>& frames, int &alpha_flag);
int png_has_animation(char * szIn);
int create_apng(image_info * img, unsigned int frames, const char * szOut);

//   jpeg encode/decode

//JPEG_COLOR_SPACE is copy from jpeglib.h
typedef enum {
  JPEGCS_UNKNOWN,            /* error/unspecified */
  JPEGCS_GRAYSCALE,          /* monochrome */
  JPEGCS_RGB,                /* red/green/blue as specified by the RGB_RED,
                             RGB_GREEN, RGB_BLUE, and RGB_PIXELSIZE macros */
  JPEGCS_YCbCr,              /* Y/Cb/Cr (also known as YUV) */
  JPEGCS_CMYK,               /* C/M/Y/K */
  JPEGCS_YCCK,               /* Y/Cb/Cr/K */
  JPEGCS_EXT_RGB,            /* red/green/blue */
  JPEGCS_EXT_RGBX,           /* red/green/blue/x */
  JPEGCS_EXT_BGR,            /* blue/green/red */
  JPEGCS_EXT_BGRX,           /* blue/green/red/x */
  JPEGCS_EXT_XBGR,           /* x/blue/green/red */
  JPEGCS_EXT_XRGB,           /* x/red/green/blue */
  /* When out_color_space it set to JCS_EXT_RGBX, JCS_EXT_BGRX, JCS_EXT_XBGR,
     or JCS_EXT_XRGB during decompression, the X byte is undefined, and in
     order to ensure the best performance, libjpeg-turbo can set that byte to
     whatever value it wishes.  Use the following colorspace constants to
     ensure that the X byte is set to 0xFF, so that it can be interpreted as an
     opaque alpha channel. */
  JPEGCS_EXT_RGBA,           /* red/green/blue/alpha */
  JPEGCS_EXT_BGRA,           /* blue/green/red/alpha */
  JPEGCS_EXT_ABGR,           /* alpha/blue/green/red */
  JPEGCS_EXT_ARGB,           /* alpha/red/green/blue */
  JPEGCS_RGB565              /* 5-bit red/6-bit green/5-bit blue */
} JPEG_COLOR_SPACE;

typedef enum {
	LARGE_SIZE,
	MEDIUM_SIZE,
	SMALL_SIZE,
} QUALITY_LEVEL;

typedef struct
{
	unsigned char       *data;
	long                width;
	long                height;
	int                 componentsPerPix;
	int                 bytePerPix;
	long                bytePerRow;
	JPEG_COLOR_SPACE    PixFormat;
	int                 orientation;
}BitmapData;


//解码jpeg文件
#ifdef __cplusplus
extern "C" {
#endif
int decodeJpgFile (const char *filename, BitmapData *bitmap, int scale_num, int scale_denom, JPEG_COLOR_SPACE cls);

//从内存解码jpeg到bitmap中
int decodeJpgData (unsigned char *jpgStream, unsigned long streamLength, BitmapData *bitmap, int scale_num, int scale_denom, JPEG_COLOR_SPACE cls);

//将bitmap中的像素数据编码成jpg到文件中
int encodeBitmapToFile(BitmapData *bitmap, const char *filename, int quality, int progressive);
int encodeBitmapToFileWithExif(BitmapData *bitmap, const char *filename, int quality, int progressive, const unsigned char * pExif, unsigned int exifLength);

//将bitmap中的像素数据编码成jpg到内存中
int encodeBitmapToBuffer(BitmapData *bitmap, unsigned char **jpgStream, unsigned long *streamLength, int quality, int progressive);
int encodeBitmapToBufferWithExif(BitmapData *bitmap, unsigned char **jpgStream, unsigned long *streamLength, int quality, int progressive, const unsigned char * pExif, unsigned int exifLength);

//获取sharpP转码最佳质量参数
int GetJpegDataBestQP(const unsigned char *pBuf, unsigned int size);
//int GetJpegDataBestQP(const unsigned char *pBuf, unsigned int size, QUALITY_LEVEL level);//
int GetJpegFileBestQP(const char *filename);
int GetJpegDataExif(const unsigned char *pBuf, unsigned int size, unsigned char * pExifBuf);
int GetJpegFileExif(const char *filename, unsigned char * pExifBuf);
#ifdef __cplusplus
}
#endif

//  png encode/decode

typedef struct _pic_data pic_data;
struct _pic_data
{
	int width, height; /* 尺寸 */
	int bit_depth;  /* 位深 */
	int flag;   /* 一个标志，表示是否有alpha通道 */
	int png8_flag;
	unsigned char *rgba; /* 图片数组 */
};

typedef struct _png_mem_encode_data  png_mem_encode_data;
struct _png_mem_encode_data
{
  unsigned char *buffer;
  int iMaxMemorySize;
  int iSize;
};

//bmp encode/decode
typedef struct _bmp_pic_data bmp_pic_data;
struct _bmp_pic_data
{
	int width, height; /* 尺寸 */
	int flag;   /* 一个标志，表示是否有alpha通道 */
	unsigned char *rgba; /* 图片数组 */
}; 

typedef struct _bmp_mem_encode_data  bmp_mem_encode_data;
struct _bmp_mem_encode_data
{
	unsigned char *buffer;
	int iMaxMemorySize;
	int iSize;
};

#define PNG_BYTES_TO_CHECK 26
#define HAVE_ALPHA 1
#define NO_ALPHA 0

/* 用于解码png图片 */
#ifdef __cplusplus
extern "C" {
#endif
int decode_png(char *filepath, pic_data *out);
//读取内存模式解码PNG
int decode_png_mem(unsigned char *pngdataStream, int nStreamLength,pic_data *out);
/* 功能：将LCUI_Graph结构中的数据写入至png文件 */
int encode_png(char *file_name , pic_data *graph);

int encode_png_mem(pic_data *graph,png_mem_encode_data *png_mem_data);

int encode_bmp(char *file_name, bmp_pic_data *gragh);

int encode_bmp_mem(bmp_pic_data *gragh,bmp_mem_encode_data *bmp_mem_data);

int decode_bmp(char *file_name , bmp_pic_data *graph);

int decode_bmp_mem(unsigned char *bmpDataStream, int nStreamLentgh,bmp_pic_data *out);

#ifdef __cplusplus
}
#endif


//gif encode/decode

typedef enum gifStatusCode {
	DECODE_GIF_SUCCEEDED           = 0,
	DECODE_GIF_ERR_OPEN_FAILED     =101,    /* And DGif possible errors. */
	DECODE_GIF_ERR_READ_FAILED     =102,
	DECODE_GIF_ERR_NOT_GIF_FILE    =103,
	DECODE_GIF_ERR_NO_SCRN_DSCR    =104,
	DECODE_GIF_ERR_NO_IMAG_DSCR    =105,
	DECODE_GIF_ERR_NO_COLOR_MAP    =106,
	DECODE_GIF_ERR_WRONG_RECORD    =107,
	DECODE_GIF_ERR_DATA_TOO_BIG    =108,
	DECODE_GIF_ERR_NOT_ENOUGH_MEM  =109,
	DECODE_GIF_ERR_CLOSE_FAILED    =110,
	DECODE_GIF_ERR_NOT_READABLE    =111,
	DECODE_GIF_ERR_IMAGE_DEFECT    =112,
	DECODE_GIF_ERR_EOF_TOO_SOON    =113
} gifStatusCode;


typedef struct stGifColorType {
	unsigned char Red, Green, Blue;
} stGifColorType;

typedef struct stColorMapObject {
	int ColorCount;
	int BitsPerPixel;
	bool SortFlag;
	stGifColorType *Colors;    /* on malloc(3) heap */
} stColorMapObject;

typedef struct
{
	int width;
	int height;
	unsigned char* pRGB;
// 	enGifRawDataFormat format;
	int delayTime;
}stGifFrame;

#ifdef __cplusplus
extern "C" {
#endif

void* GifDecoderOpenStream(unsigned char* pStreamBuf, int len);
bool GifDecoderDecodeFrame(void* h, stGifFrame* pFrame);
void GifDecoderClose(void* h);
stColorMapObject* GifDecoderGetGlobalColorMap(void* h);
int GifDecoderGetWidth(void* h);
int GifDecoderGetHeight(void* h);
int GifDecoderGetFrameCount(void* h);
bool GifDecoderUseLocalColorMap(void* h);
bool GifDecoderHasAlpha(void* h);

void* GifEncoderOpen(const char *file_name, int width, int height, bool hasAlpha, stColorMapObject* stInfo, int level);
void* GifEncoderOpenStream(unsigned char* pStreamBuf, int len ,int width, int height, bool hasAlpha, stColorMapObject* pInfo, int level);
bool GifEncoderEncodeFrame(void* h, stGifFrame* pFrame);
int GifEncoderClose(void* h);//返回值为GIF长度
int GifEncoderError(void* h);
gifStatusCode GifDecoderError(void* h);
#ifdef __cplusplus
}
#endif


//image process

typedef enum RotateMode {
	eRotate0 = 0,  // No rotation.
	eRotate90 = 90,  // Rotate 90 degrees clockwise.
	eRotate180 = 180,  // Rotate 180 degrees.
	eRotate270 = 270,  // Rotate 270 degrees clockwise.
} RotateModeEnum;


void rotateRGB(const unsigned char* src, unsigned char* dst,
	int src_width, int src_height, enum RotateMode mode);

void rotateRGBA(const unsigned char* src, unsigned char* dst,
	int src_width, int src_height, enum RotateMode mode);

#endif
