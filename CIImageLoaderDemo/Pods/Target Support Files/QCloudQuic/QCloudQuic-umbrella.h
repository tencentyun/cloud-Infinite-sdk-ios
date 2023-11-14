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

#import "QCloudQuicVersion.h"
#import "QCloudQuic.h"
#import "QCloudQuicConfig.h"
#import "QCloudQuicDataTask.h"
#import "QCloudQuicSession.h"
#import "TquicConnection.h"
#import "TquicDNS.h"
#import "Tquicnet.h"
#import "TquicRequest.h"
#import "TquicResponse.h"

FOUNDATION_EXPORT double QCloudQuicVersionNumber;
FOUNDATION_EXPORT const unsigned char QCloudQuicVersionString[];

