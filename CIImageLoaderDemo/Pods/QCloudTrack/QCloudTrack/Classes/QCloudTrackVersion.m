#import "QCloudTrackVersion.h"
NSString * const QCloudTrackModuleVersion = @"6.3.4";
NSString * const QCloudTrackModuleName = @"QCloudTrack";
@interface QCloudQCloudTrackLoad : NSObject
@end

@implementation QCloudQCloudTrackLoad
+ (void) load
{
    Class cla = NSClassFromString(@"QCloudSDKModuleManager");
    if (cla) {
        NSMutableDictionary* module = [@{
                                 @"name" : QCloudTrackModuleName,
                                 @"version" : QCloudTrackModuleVersion
                                 } mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        id share = [cla performSelector:@selector(shareInstance)];
        [share performSelector:@selector(registerModuleByJSON:) withObject:module];
#pragma clang diagnostic pop
    }
}
@end