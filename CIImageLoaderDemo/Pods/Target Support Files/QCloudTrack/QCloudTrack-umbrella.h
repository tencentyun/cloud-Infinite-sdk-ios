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

#import "QCloudTrackVersion.h"
#import "QCloudBaseTrackService.h"
#import "QCloudIReport.h"
#import "QCloudTrack.h"
#import "QCloudTrackConstants.h"
#import "QCloudTrackService.h"
#import "QCloudTrackNetworkUtils.h"
#import "QCloudBeaconTrackService.h"
#import "QCloudSimpleBeaconTrackService.h"
#import "QCloudTrackBeacon.h"

FOUNDATION_EXPORT double QCloudTrackVersionNumber;
FOUNDATION_EXPORT const unsigned char QCloudTrackVersionString[];

