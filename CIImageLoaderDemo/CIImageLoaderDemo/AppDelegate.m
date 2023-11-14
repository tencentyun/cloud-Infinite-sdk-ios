//
//  AppDelegate.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/7/17.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "AppDelegate.h"
//#import <SDWebImage/SDWebImage.h>
//#import <SDWebImage-CloudInfinite.h>
#import "MainViewController.h"
#include <unistd.h>
//#import "CIDNSLoader.h"
#import "CIImageDownloader.h"
#import "SDWebImage-CloudInfinite.h"
//#import "QCloudQuicConfig.h"
//#import "AVIFDecoderHelper.h"
@interface AppDelegate ()
//@property (nonatomic,strong)CIDNSLoader * dnsloader;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    方式一全局使用TPG
//    [[TPGDownloaderConfig sharedConfig] addTPGRegularExpress:@"http(s)?:.*" paramsType:CILoadTypeUrlFooter];
//
//    // 排除主题色的请求
//    [[TPGDownloaderConfig sharedConfig] addExcloudeTPGRegularExpress:@"http(s)?:.*imageAve"];

    _keyWindow = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    usleep(10);
    UINavigationController * rootNAV = [[UINavigationController alloc]initWithRootViewController:MainViewController.new];
    _keyWindow.rootViewController = rootNAV;
    _keyWindow.backgroundColor = UIColor .whiteColor;
    [_keyWindow makeKeyAndVisible];
    
//    [CIImageDownloader sharedDownloader].enableQuic = YES;
//    [CIImageDownloader sharedDownloader].quicWhiteList = @[@"mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com"];
//    [QCloudQuicConfig shareConfig].race_type = QCloudRaceTypeQUICHTTP;
    
    
//    [CIImageDownloader sharedDownloader].retryCount = 2;
//    [CIImageDownloader sharedDownloader].sleepTime = 2;
//    [CIImageDownloader sharedDownloader].canUseCIImageDownloader = ^BOOL(NSURL * _Nonnull url, SDWebImageOptions options, SDWebImageContext * _Nonnull context) {
//        return YES;
//    };
//    [CIImageDownloader sharedDownloader].canUseRetryWhenError = ^BOOL(QCloudURLSessionTaskData * _Nonnull task, NSError * _Nonnull error) {
//        return YES;
//    };
    [UIView setLoadOriginalImageWhenError:YES];
    [UIView setLoadTPGAVIFImageErrorHandler:^NSString * _Nullable(NSString * _Nonnull url) {
        return url;
    }];
    
    [UIView setTPGAVIFImageErrorObserver:^(NSString * _Nonnull url, NSError * _Nonnull error) {
        
    }];
    
//    [self setupTencentDNS];
//
//    [CIImageDownloader sharedDownloader].customConcurrentCount = 3;
//    [CIImageDownloader sharedDownloader].maxConcurrentCount = 10;

    return YES;
}

//-(void)setupTencentDNS{
//    DnsConfig config;
//    config.appId = @"appId";
//    config.dnsIp = @"dnsIp";
//    config.dnsId = 96766;
//    config.dnsKey = @"dnsKey";//des的密钥
//    config.encryptType = HttpDnsEncryptTypeDES;
//    config.debug = YES;
//    config.timeout = 5000;
//    self.dnsloader = [[CIDNSLoader alloc] initWithConfig:config];
//    [QCloudHttpDNS shareDNS].delegate = self.dnsloader;
//
//}

@end
