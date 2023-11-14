//
//  AVIFTests.m
//  CIImageLoaderDemoTests
//
//  Created by garenwang on 2023/7/5.
//  Copyright © 2023 garenwang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CITestConfig.h"
#import <AVIFDecoderHelper.h>
#import <UIImageView+AVIF.h>
#import <UIImage+AVIFDecode.h>
#import <AVIFImageDecoder.h>
@interface AVIFTests : XCTestCase

@end

@implementation AVIFTests

- (void)testDecodeAVIF {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeAVIF"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testFile]]];
        NSError * error;
        UIImage * image = [AVIFDecoderHelper imageDataDecode:data error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testDecodeNotAVIF {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeNotAVIF"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:testFile]];
        NSError * error;
        UIImage * image = [AVIFDecoderHelper imageDataDecode:data error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testDecodeNULL {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeNotAVIF"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@""]];
        NSError * error;
        UIImage * image = [AVIFDecoderHelper imageDataDecode:data error:&error];
        XCTAssertNil(image);
        XCTAssertNotNil(error);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testImageType {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeNotAVIF"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@""]];
        BOOL result = [AVIFDecoderHelper isAVIFImage:data];
        XCTAssertFalse(result);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:testFile]];
        result = [AVIFDecoderHelper isAVIFImage:data];
        XCTAssertFalse(result);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testFile]]];
        result = [AVIFDecoderHelper isAVIFImage:data];
        XCTAssertTrue(result);
        
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

-(void)testUIimageDecode{
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeAVIF"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testFile]]];
        NSError * error;
        UIImage * image = [UIImage AVIFImageWithContentsOfData:data scale:2.0 rect:CGRectMake(100, 100, 100, 100) error:&error];
        XCTAssertEqual(image.size.width, 50);
        XCTAssertEqual(image.size.height, 50);
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",testFile]]];
        image = [UIImage AVIFImageWithContentsOfData:data scale:2.0 rect:CGRectMake(100, 100, 100, 100) error:&error];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",testErrorFile]]];
        image = [UIImage AVIFImageWithContentsOfData:data scale:2.0 rect:CGRectMake(100, 100, 100, 100) error:&error];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",testErrorFile]]];
        image = [UIImage AVIFImageWithContentsOfData:data scale:2.0 rect:CGRectMake(100, 100, 100, 100)];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        image = [UIImage AVIFImageWithContentsOfData:[NSData new] scale:2.0 rect:CGRectMake(100, 100, 100, 100) error:&error];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
    
        image = [UIImage AVIFImageWithContentsOfData:[@"123" dataUsingEncoding:NSUTF8StringEncoding] scale:2.0 rect:CGRectMake(100, 100, 100, 100) error:&error];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        image = [UIImage AVIFImageWithContentsOfData:[@"123" dataUsingEncoding:NSUTF8StringEncoding] scale:2.0 rect:CGRectMake(100, 100, 100, 100)];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

-(void)testAVIFUIimageView{

    XCTestExpectation * expectation = [self expectationWithDescription:@"testAVIFUIimageView"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/avif",testFile]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setAvifImageWithData:data loadComplete:^(NSData * _Nullable data, UIImage * _Nullable image, NSError * _Nullable error) {
                XCTAssertNil(error);
                XCTAssertNotNil(image);
                [expectation fulfill];
            }];
        });
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testAVIFUIimageView"];
    [imageView setAvifImageWithPath:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"avif" ofType:@"jpg"]] loadComplete:^(NSData * _Nullable data, UIImage * _Nullable image, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testAVIFUIimageView"];
    [imageView setAvifImageWithPath:[NSURL URLWithString:@""] loadComplete:^(NSData * _Nullable data, UIImage * _Nullable image, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    AVIFImageDecoder * tpgDecoder = [[AVIFImageDecoder alloc]init];
    BOOL result = [tpgDecoder canDecodeFromData:nil];
    XCTAssertTrue(result == false);

    result = [tpgDecoder canDecodeFromData:[@"test" dataUsingEncoding:NSUTF8StringEncoding]];
    XCTAssertTrue(result == false);
    
    result = [tpgDecoder canEncodeToFormat:0];
    XCTAssertTrue(result == false);
    
    result = [tpgDecoder encodedDataWithImage:nil format:0 options:nil];
    XCTAssertTrue(result == false);
}
@end
