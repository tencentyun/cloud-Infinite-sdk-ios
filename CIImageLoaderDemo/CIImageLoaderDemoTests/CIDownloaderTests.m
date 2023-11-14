//
//  CIDownloaderTests.m
//  CIImageLoaderDemoTests
//
//  Created by garenwang on 2023/7/5.
//  Copyright © 2023 garenwang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CIImageDownloader.h>
//#import <QCloudQuicConfig.h>
#import "CITestConfig.h"
//#import "CIDNSLoader.h"
#import "CIImageDownloader.h"
#import "SDWebImage-CloudInfinite.h"
#import <CIImageAveDecoder.h>
#import "NSData+DecodeError.h"
#import "SDWebImageDownloaderConfig+CI.h"
#import "CIGetObjectRequest.h"
@interface CIDownloaderTests : XCTestCase

@end

@implementation CIDownloaderTests

- (void)testError{
    NSData * data = [NSData new];
    data.decodeError = [[NSError alloc]initWithDomain:@"test" code:0 userInfo:nil];
    NSError * error = data.decodeError;
    NSLog(@"%@",error);
    
    [SDWebImageDownloaderConfig defaultDownloaderConfig].enableQuic = YES;
    BOOL enableQuic = [SDWebImageDownloaderConfig defaultDownloaderConfig].enableQuic;
}

- (void)testQuic {
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"CIDownloaderTests"];
    
    [[SDImageCache sharedImageCache] clearWithCacheType:SDImageCacheTypeAll completion:nil];
//    [CIImageDownloader sharedDownloader].enableQuic = YES;
//    [CIImageDownloader sharedDownloader].quicWhiteList = @[@"mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com"];
//    [QCloudQuicConfig shareConfig].race_type = QCloudRaceTypeQUICHTTP;
    
    [CIImageDownloader sharedDownloader].retryCount = 2;
    [CIImageDownloader sharedDownloader].sleepTime = 2;
    [CIImageDownloader sharedDownloader].canUseCIImageDownloader = ^BOOL(NSURL * _Nonnull url, SDWebImageOptions options, SDWebImageContext * _Nonnull context) {
        return YES;
    };
    [CIImageDownloader sharedDownloader].canUseRetryWhenError = ^BOOL(QCloudURLSessionTaskData * _Nonnull task, NSError * _Nonnull error) {
        return YES;
    };
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:testQuicFile] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
   
}

//- (void)testHttpDNS {
//
//    XCTestExpectation * expectation = [self expectationWithDescription:@"testHttpDNS"];
//
//    DnsConfig config;
//    config.appId = @"VS065K4POAYA9P1O";
//    config.dnsIp = @"119.29.29.98";
//    config.dnsId = 96766;
//    config.dnsKey = @"cOp66erx";//des的密钥
//    config.encryptType = HttpDnsEncryptTypeDES;
//    config.debug = YES;
//    config.timeout = 5000;
//    CIDNSLoader * dnsloader = [[CIDNSLoader alloc] initWithConfig:config];
//    [QCloudHttpDNS shareDNS].delegate = dnsloader;
//    NSString * ip = [dnsloader resolveDomain:@"mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com"];
//    XCTAssertNotNil(ip);
//    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:testQuicFile] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        XCTAssertNotNil(image);
//        XCTAssertTrue(image.size.width > 0);
//        [expectation fulfill];
//    }];
//    [self waitForExpectationsWithTimeout:60 handler:nil];
//}

-(void)testOriginalTPG{
    
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"testOriginalTPG"];
    [UIView setLoadOriginalImageWhenError:YES];
    [UIView setLoadTPGAVIFImageErrorHandler:^NSString * _Nullable(NSString * _Nonnull url) {
        
        return testFile;
    }];

    [UIView setTPGAVIFImageErrorObserver:^(NSString * _Nonnull url, NSError * _Nonnull error) {
        NSLog(@"%@:%@",url,error);
    }];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/tpg",testErrorFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0);
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

-(void)testOriginalAVIF{
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"testOriginalAVIF"];
    [UIView setLoadOriginalImageWhenError:YES];
    [UIView setLoadTPGAVIFImageErrorHandler:^NSString * _Nullable(NSString * _Nonnull url) {
        
        return testFile;
    }];

    [UIView setTPGAVIFImageErrorObserver:^(NSString * _Nonnull url, NSError * _Nonnull error) {
        NSLog(@"%@:%@",url,error);
    }];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testErrorFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0);
    
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testAveCoder {
    CIImageAveDecoder * tpgDecoder = [[CIImageAveDecoder alloc]init];
    BOOL result = [tpgDecoder canDecodeFromData:nil];
    XCTAssertTrue(result == false);

    result = [tpgDecoder canDecodeFromData:[@"test" dataUsingEncoding:NSUTF8StringEncoding]];
    XCTAssertTrue(result == false);
    
    result = [tpgDecoder decodedImageWithData:nil options:nil];
    XCTAssertTrue(result == false);
    
    result = [tpgDecoder decodedImageWithData:[@"test" dataUsingEncoding:NSUTF8StringEncoding] options:nil];
    XCTAssertTrue(result == false);
    
    result = [tpgDecoder canEncodeToFormat:0];
    XCTAssertTrue(result == false);
    
    result = [tpgDecoder encodedDataWithImage:nil format:0 options:nil];
    XCTAssertTrue(result == false);
    
    result = [tpgDecoder decodedImageWithData:[NSJSONSerialization dataWithJSONObject:@{@"RGB":@"ffffff"} options:NSJSONWritingFragmentsAllowed error:nil ] options:nil];
    XCTAssertTrue(result == false);
    
    result = [tpgDecoder decodedImageWithData:[NSJSONSerialization dataWithJSONObject:@{@"RGB":@"ffffffff"} options:NSJSONWritingFragmentsAllowed error:nil] options:nil];
    XCTAssertTrue(result == true);
}

-(void)testCodeCoverage{
    UIView * view = [UIView new];
    [view performSelector:@selector(transferOrgUrlString:)withObject:@"http://test.com/test.jpg?imageMogr2/format/avif"];
    
    [view performSelector:@selector(transferOrgUrlString:)withObject:@"http://test.com/test.jpg?imageMogr2/format/tpg"];
    
    [view sd_CI_preloadWithAveColor:testFile];
    
    [[SDImageAWebPCoder sharedCoder] canEncodeToFormat:SDImageFormatWebP];
    [[SDImageAWebPCoder sharedCoder] encodedDataWithImage:UIImage.new format:SDImageFormatWebP options:0];
    
    [[CIImageDownloader sharedDownloader] setSleepTime:10];
    [[CIImageDownloader sharedDownloader] setRetryCount:10];
    [[CIImageDownloader sharedDownloader] setMaxConcurrentCount:10];
    [[CIImageDownloader sharedDownloader] setCustomConcurrentCount:10];
    [[CIImageDownloader sharedDownloader] setValue:@"header" forHTTPHeaderField:@"header"];
    [[CIImageDownloader sharedDownloader] valueForHTTPHeaderField:@"header"];
}

-(void)testCIGetObjectRequest{
    NSError * error;
    CIGetObjectRequest * request = CIGetObjectRequest.new;
    [request buildRequestData:&error];
    XCTAssertNotNil(error);
}
@end
