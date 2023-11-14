//
//  CISDWebImageTests.m
//  CIImageLoaderDemoTests
//
//  Created by garenwang on 2023/7/5.
//  Copyright © 2023 garenwang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CITestConfig.h"
#import <SDWebImage/SDWebImage.h>
#import <CITransformation.h>
#import <UIImageView+CI.h>
#import <UIButton+CI.h>

@interface CISDWebImageTests : XCTestCase

@end

@implementation CISDWebImageTests

- (void)testSDQuic {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testSDLoadAvif"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testSDLoadJpg"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:testFile] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0 && image.size.height > 0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testSDLoadAvif {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testSDLoadAvif"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testSDLoadJpg"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:testFile] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0 && image.size.height > 0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testSDLoadAvif1 {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testSDLoadAvif"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    CITransformation * trans = [[CITransformation alloc]init];
    [trans setFormatWith:CIImageTypeAVIF];
    [trans setCutWithWidth:100 height:100 dx:100 dy:100];
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] transformation:trans completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width == 100 && image.size.height == 100);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testSDLoadJpg"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:testFile] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0 && image.size.height > 0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testSDLoadTPG {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testSDLoadTPG"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/tpg",testFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0 && image.size.height > 0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testSDLoadJpg"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:testFile] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0 && image.size.height > 0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testSDLoadTPG1 {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testSDLoadTPG1"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    CITransformation * trans = [[CITransformation alloc]init];
    [trans setFormatWith:CIImageTypeAVIF];
    [trans setCutWithWidth:100 height:100 dx:100 dy:100];
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] transformation:trans completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width == 100 && image.size.height == 100);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testSDLoadJpg"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:testFile] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0 && image.size.height > 0);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

-(void)testWebp{
    XCTestExpectation * expectation = [self expectationWithDescription:@"testWebp"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/webp",testFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    
}

-(void)testGifToTPG{
    XCTestExpectation * expectation = [self expectationWithDescription:@"testGifToTPG"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/tpg",testPngFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testGifToTPG1"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/tpg",testGifFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

-(void)testGifToAvif{
    XCTestExpectation * expectation = [self expectationWithDescription:@"testGifToAvif"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testPngFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testGifToAvif1"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testGifFile]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testButtonLoadImage {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testButtonLoadImage"];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    CITransformation * trans = [[CITransformation alloc]init];
    [trans setFormatWith:CIImageTypeAVIF];
    [trans setCutWithWidth:100 height:100 dx:100 dy:100];
    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal transformation:trans completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width == 100 && image.size.height == 100);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
        
    expectation = [self expectationWithDescription:@"testButtonLoadImage1"];
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        XCTAssertTrue(image.size.width > 0 && image.size.height > 0);
        [expectation fulfill];
    }];;
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:0 transformation:trans];
    
    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:0 transformation:trans];
}

-(void)testUIViewCI{
    UIButton * button = [UIButton new];
    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal transformation:nil];
    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil transformation:nil];
    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil];
    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil context:nil];

    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal transformation:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];

    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil transformation:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];

    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [button sd_CI_setImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];

    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal transformation:nil];
    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil transformation:nil];
    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil];
    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil context:nil];

    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal transformation:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];

    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil transformation:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];

    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [button sd_CI_setBackgroundImageWithURL:[NSURL URLWithString:testFile] forState:UIControlStateNormal placeholderImage:nil options:0 transformation:nil context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}

-(void)testImageView{
    UIImageView * imageView = [UIImageView new];
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] transformation:nil];
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] placeholderImage:nil transformation:nil];
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] placeholderImage:nil options:0 transformation:nil];
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] placeholderImage:nil options:0 transformation:nil context:nil];
    
    
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] transformation:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] placeholderImage:nil transformation:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] placeholderImage:nil options:0 transformation:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] placeholderImage:nil options:0 transformation:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] placeholderImage:nil options:0 transformation:nil context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    [imageView sd_CI_setImageWithURL:[NSURL URLWithString:testFile] placeholderImage:nil options:0 transformation:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}
@end
