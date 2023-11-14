#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AVIFDecoderHelper.h"
#import "UIImage+AVIFDecode.h"
#import "UIImageView+AVIF.h"
#import "avif.h"
#import "dav1d.h"
#import "internal.h"
#import "CIQualityDataUploader.h"
#import "CIGetObjectRequest.h"
#import "CIImageDownloader.h"
#import "QCloudHTTPRequestOperation+CI.h"
#import "SDWebImageDownloaderConfig+CI.h"
#import "CIImageLoadRequest.h"
#import "CIMemoryCache.h"
#import "CIResponsiveTransformation.h"
#import "CISmartFaceTransformation.h"
#import "CITransformActionProtocol.h"
#import "CITransformation.h"
#import "CloudInfinite.h"
#import "CloudInfiniteEnum.h"
#import "CloudInfiniteTools.h"
#import "CIGaussianBlur.h"
#import "CIImageChangeType.h"
#import "CIImageRotate.h"
#import "CIImageSharpen.h"
#import "CIImageStrip.h"
#import "CIImageTailor.h"
#import "CIImageZoom.h"
#import "CIQualityChange.h"
#import "CIWaterImageMark.h"
#import "CIWaterTextMark.h"
#import "CIImageLoader.h"
#import "CIImageRequest.h"
#import "AVIFImageDecoder.h"
#import "CIDownloaderConfig.h"
#import "CIDownloaderManager.h"
#import "CIImageAveDecoder.h"
#import "CIWebImageDownloader.h"
#import "CIWebpImageDecoder.h"
#import "NSData+DecodeError.h"
#import "SDWebImage-CloudInfinite.h"
#import "TPGImageDecoder.h"
#import "UIButton+CI.h"
#import "UIImageView+CI.h"
#import "UIView+CI.h"
#import "TPGDecoderHelper.h"
#import "UIImage+TPGDecode.h"
#import "UIImageView+TPG.h"
#import "imageUtil.h"
#import "tpgDecoder.h"
#import "CIQualityDataUploader.h"

FOUNDATION_EXPORT double CloudInfiniteVersionNumber;
FOUNDATION_EXPORT const unsigned char CloudInfiniteVersionString[];

