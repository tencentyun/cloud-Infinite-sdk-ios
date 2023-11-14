//
//  TPGTests.m
//  CIImageLoaderDemoTests
//
//  Created by garenwang on 2023/7/5.
//  Copyright © 2023 garenwang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CITestConfig.h"
#import <TPGDecoderHelper.h>
#import <UIImageView+TPG.h>
#import <UIImage+TPGDecode.h>
#import <TPGImageDecoder.h>
@interface TPGTests : XCTestCase

@end

@implementation TPGTests


- (void)testDecodeTPG {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeTPG"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/tpg",testFile]]];
        NSError * error;
        UIImage * image = [TPGDecoderHelper imageDataDecode:data error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testDecodeNotTPG {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeNotTPG"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:testFile]];
        NSError * error;
        UIImage * image = [TPGDecoderHelper imageDataDecode:data error:&error];
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testDecodeNULL {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeNotTPG"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@""]];
        NSError * error;
        UIImage * image = [TPGDecoderHelper imageDataDecode:data error:&error];
        XCTAssertNil(image);
        XCTAssertNotNil(error);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testImageType {
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeNotTPG"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@""]];
        BOOL result = [TPGDecoderHelper isTPGImage:data];
        XCTAssertFalse(result);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:testFile]];
        result = [TPGDecoderHelper isTPGImage:data];
        XCTAssertFalse(result);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/tpg",testFile]]];
        result = [TPGDecoderHelper isTPGImage:data];
        XCTAssertTrue(result);
        
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

-(void)testUIimageDecode{
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeTPG"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/tpg",testFile]]];
        NSError * error;
        UIImage * image = [UIImage TPGImageWithContentsOfData:data scale:2.0 rect:CGRectMake(100, 100, 100, 100) error:&error];
        XCTAssertEqual(image.size.width, 50);
        XCTAssertEqual(image.size.height, 50);
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",testFile]]];
        image = [UIImage TPGImageWithContentsOfData:data scale:2.0 rect:CGRectMake(100, 100, 100, 100) error:&error];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",testFile]]];
        image = [UIImage TPGImageWithContentsOfData:data scale:2.0 rect:CGRectMake(100, 100, 100, 100)];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",testFile]]];
        image = [UIImage TPGImageWithContentsOfData:data error:&error];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",testFile]]];
        image = [UIImage TPGImageWithContentsOfData:data];
        XCTAssertNotNil(error);
        XCTAssertNil(image);
        
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

-(void)testTPGUIimageView{
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"testDecodeTPG"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/format/tpg",testFile]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setTpgImageWithData:data loadComplete:^(NSData * _Nullable data, UIImage * _Nullable image, NSError * _Nullable error) {
                XCTAssertNil(error);
                XCTAssertNotNil(image);
                [expectation fulfill];
            }];
        });
    });
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    expectation = [self expectationWithDescription:@"testTPGUIimageView"];
    
    [imageView setTpgImageWithPath:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tpg" ofType:@"jpg"]] loadComplete:^(NSData * _Nullable data, UIImage * _Nullable image, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(image);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
    
    TPGImageDecoder * tpgDecoder = [[TPGImageDecoder alloc]init];
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
