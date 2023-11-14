//
//  CloudinfiniteTests.m
//  CIImageLoaderDemoTests
//
//  Created by garenwang on 2023/7/5.
//  Copyright © 2023 garenwang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CloudInfinite.h>
#import "CITestConfig.h"
#import <UIImage+TPGDecode.h>
#import <CIImageLoader.h>
#import <CIWebImageDownloader.h>
#import <CIDownloaderConfig.h>
#import <CISmartFaceTransformation.h>
#import <CIDownloaderManager.h>
#import "CloudInfiniteTools.h"
#import "CIImageLoadRequest.h"
@interface CloudinfiniteTests : XCTestCase

@end

@implementation CloudinfiniteTests

- (void)testLoadImage {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testLoadImage"];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}


- (void)testLoadImage2 {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testLoadImage2"];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testLoadImage3 {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testLoadImage3"];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        [[CIImageLoader shareLoader] display:[UIImageView new] loadRequest:request placeHolder:UIImage.new loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testErrorFile"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [cloudInfinite requestWithBaseUrl:testErrorFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        [[CIImageLoader shareLoader] display:[UIImageView new] loadRequest:request placeHolder:UIImage.new loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNotNil(error);
            [expectation fulfill];
        }];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testLoadImage4 {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testLoadImage4"];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
    [[CIImageLoader shareLoader] preloadWithAveColor:[UIImageView new] objectUrl:testFile complete:^(UIColor * _Nonnull color) {
        XCTAssertNotNil(color);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testErrorFile"];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
    [[CIImageLoader shareLoader] preloadWithAveColor:[UIImageView new] objectUrl:testErrorFile complete:^(UIColor * _Nonnull color) {
        XCTAssertNil(color);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testErrorFile"];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
    [[CIImageLoader shareLoader] preloadWithAveColor:[UIImageView new] objectUrl:testNotFountFile complete:^(UIColor * _Nonnull color) {
        XCTAssertNil(color);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testTransformationZoom {
    XCTestExpectation * expectation = [self expectationWithDescription:@"setZoomWithPercent"];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setZoomWithArea:100 *100];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    XCTestExpectation * expectation1 = [self expectationWithDescription:@"setZoomWithWidth"];
    CloudInfinite * cloudInfinite1 = [CloudInfinite new];
    CITransformation * transform1 = [CITransformation new];
    [transform1 setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform1 setZoomWithPercent:50 scaleType:ScalePercentTypeALL];
    [cloudInfinite1 requestWithBaseUrl:testFile transform:transform1 request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation1 fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    XCTestExpectation * expectation2 = [self expectationWithDescription:@"setZoomWithArea"];
    CloudInfinite * cloudInfinite2 = [CloudInfinite new];
    CITransformation * transform2 = [CITransformation new];
    [transform2 setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform2 setZoomWithWidth:100 height:100 scaleType:ScaleTypeOnlyWidth];
    [cloudInfinite2 requestWithBaseUrl:testFile transform:transform2 request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation2 fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}


- (void)testTransformationCut {
    XCTestExpectation * expectation = [self expectationWithDescription:@"setCutWithWidth"];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setCutWithWidth:100 height:100 dx:100 dy:100];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setCutWithIRadius"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setCutWithIRadius:100];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setCutWithRRadius"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setCutWithRRadius:100];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    
    expectation = [self expectationWithDescription:@"setCutWithRRadius"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setCutWithScrop:100 height:100];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setCutWithCrop"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setCutWithCrop:100 height:100];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setCutWithCrop"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setCutWithCrop:100 height:100 gravity:CIGravityNorthWest];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setRotateWith"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setRotateWith:90];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setRotateAutoOrient"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setRotateAutoOrient];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setRotateAutoOrient1"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setCgif:50];
    [transform setInterlace:0];
    [transform setRotateAutoOrient];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
}

- (void)testTransformationsetBlurRadius {
    XCTestExpectation * expectation = [self expectationWithDescription:@"setBlurRadius"];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setBlurRadius:25 sigma:100];
    [transform setBlurRadius:0 sigma:0];
    [transform setBlurRadius:51 sigma:100];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setSharpenWith"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setSharpenWith:100];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
}


- (void)testTransformationWaterMark {
    XCTestExpectation * expectation = [self expectationWithDescription:@"setWaterMarkText"];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setWaterMarkText:@"123" font:[UIFont systemFontOfSize:15] textColor:UIColor.redColor dissolve:10 gravity:CIGravityEast dx:10 dy:10 batch:1 degree:90];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setWaterMarkWithImageUrl"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setWaterMarkWithImageUrl:@"test" gravity:CIGravityEast dx:10 dy:10 blogo:CIWaterImageMarkBlogoNone];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
}

- (void)testTransformationQuality {
    XCTestExpectation * expectation = [self expectationWithDescription:@"setQualityWithQuality"];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setQualityWithQuality:50 type:CIQualityChangeAbsolute];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setWaterMarkWithImageUrl"];
    cloudInfinite = [CloudInfinite new];
    transform = [CITransformation new];
    [transform setFormatWith:CIImageTypeAUTO options:CILoadTypeUrlFooter];
    [transform setImageStrip];
    [transform setViewBackgroudColorWithImageAveColor:YES];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setWaterMarkWithImageUrl"];
    cloudInfinite = [CloudInfinite new];
    CISmartFaceTransformation * transform1 = [[CISmartFaceTransformation alloc]initWithView:[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)]];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform1 request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"setWaterMarkWithImageUrl"];
    cloudInfinite = [CloudInfinite new];
    CIResponsiveTransformation * transform2 = [[CIResponsiveTransformation alloc]initWithView:[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)] scaleType:ScaleTypeOnlyWidth];
    [cloudInfinite requestWithBaseUrl:testFile transform:transform2 request:^(CIImageLoadRequest * _Nonnull request) {
        XCTAssertNotNil(request.url);
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            XCTAssertNil(error);
            XCTAssertNotNil(data);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    
}

- (void)testCIWebImageDownloader {
    CIWebImageDownloader * loader = [[CIWebImageDownloader alloc]initWithHeader:@{}];
    [loader setHttpHeaderField:@{}];
    [loader requestImageWithURL:[NSURL URLWithString:testFile] options:0 context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
        }];
}

-(void)testConfig{
    CIDownloaderConfig * config = [CIDownloaderConfig sharedConfig];
    [config addExcloudeTPGRegularExpress:@""];
    [config addTPGRegularExpress:@"" paramsType:CILoadTypeUrlFooter];
    
    CIDownloaderManager * manager = [CIDownloaderManager sharedManager];
    [manager getDownloaderWithHeader:@{@"test":@"test"}];
}



-(void)testCIImageFormat{
    NSString * type = [CloudInfiniteTools imageTypeToString:CIImageTypeTPG];
    XCTAssertTrue([type isEqualToString: @"tpg"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypeAUTO];
    XCTAssertTrue([type isEqualToString:@"*"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypePNG];
    XCTAssertTrue([type isEqualToString:@"png"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypeJPG];
    XCTAssertTrue([type isEqualToString:@"jpg"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypeBMP];
    XCTAssertTrue([type isEqualToString:@"bmp"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypeGIF];
    XCTAssertTrue([type isEqualToString:@"gif"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypeHEIC];
    XCTAssertTrue([type isEqualToString:@"heif"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypeWEBP];
    XCTAssertTrue([type isEqualToString:@"webp"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypeYJPEG];
    XCTAssertTrue([type isEqualToString:@"yjpeg"]);
    type = [CloudInfiniteTools imageTypeToString:CIImageTypeAVIF];
    XCTAssertTrue([type isEqualToString:@"avif"]);
}
///// 图片格式转化字符串
///// @param format 图片格式枚举
//+(NSString *)imageTypeToString:(CIImageFormat )format;
//
//
///// 水印位置转化字符串
///// @param gravity 水印位置
//+ (NSString *)gravityToString:(CloudInfiniteGravity)gravity;
//
//
///// 颜色转化字符串
///// @param color 颜色对象
//+ (NSString *)colorToString:(UIColor *)color;
//
//
///// 字符串安全base64编码
///// @param string 字符串
//+ (NSString *)base64DecodeString:(NSString *)string;
-(void)testCloudInfiniteGravity{

    NSString * type = [CloudInfiniteTools gravityToString:CIGravityNone];
    XCTAssertTrue([type isEqualToString:@"southeast"]);
    type = [CloudInfiniteTools gravityToString:CIGravityNorthWest];
    XCTAssertTrue([type isEqualToString:@"NorthWest".lowercaseString]);
    type = [CloudInfiniteTools gravityToString:CIGravityNorth];
    XCTAssertTrue([type isEqualToString:@"North".lowercaseString]);
    type = [CloudInfiniteTools gravityToString:CIGravityNorthEast];
    XCTAssertTrue([type isEqualToString:@"NorthEast".lowercaseString]);
    type = [CloudInfiniteTools gravityToString:CIGravityWest];
    XCTAssertTrue([type isEqualToString:@"West".lowercaseString]);
    type = [CloudInfiniteTools gravityToString:CIGravityEast];
    XCTAssertTrue([type isEqualToString:@"East".lowercaseString]);
    type = [CloudInfiniteTools gravityToString:CIGravityCenter];
    XCTAssertTrue([type isEqualToString:@"Center".lowercaseString]);
    type = [CloudInfiniteTools gravityToString:CIGravitySouthWest];
    XCTAssertTrue([type isEqualToString:@"SouthWest".lowercaseString]);
    type = [CloudInfiniteTools gravityToString:CIGravitySouth];
    XCTAssertTrue([type isEqualToString:@"South".lowercaseString]);
    type = [CloudInfiniteTools gravityToString:CIGravitySouthEast];
    XCTAssertTrue([type isEqualToString:@"SouthEast".lowercaseString]);

    
}

-(void)testCodeCoverage{
    CIImageLoadRequest * request = [[CIImageLoadRequest alloc]initWithBaseURL:@"http://test.com"];
    request = [[CIImageLoadRequest alloc]initWithBaseURL:@"http://test.com/test.jpg"];
    request = [[CIImageLoadRequest alloc]initWithBaseURL:@"http://test.com/test.jpg?test"];
    request = [[CIImageLoadRequest alloc]initWithBaseURL:@"http://test.com/test.jpg?name=test"];
    request = [[CIImageLoadRequest alloc]initWithBaseURL:@"http://test.com/test.jpg?name=test&"];
    request = [[CIImageLoadRequest alloc]initWithBaseURL:@"http://test.com/test.jpg?name=test&age=123"];
}
@end
