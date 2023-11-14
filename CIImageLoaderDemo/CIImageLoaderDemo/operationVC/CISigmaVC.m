//
//  CISigmaVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/13.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CISigmaVC.h"

@interface CISigmaVC ()
@property (nonatomic,strong)CISlider * radiusSlider;

@property (nonatomic,strong)CISlider * sigmaSlider;


@end

@implementation CISigmaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notSupportGif = YES;
    self.collectionImagesHeight.constant = 120;
}

- (void)buildOperationView{
    [super buildOperationView];
    UILabel * sigmaTitle = [UILabel new];
    [self.operationView addSubview:sigmaTitle];
    [sigmaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.operationView.top).offset(16);
        make.height.equalTo(20);
        make.width.equalTo(200);
    }];
    
    CISlider *radiusSlider = [CISlider new];
    radiusSlider.titleString = @"模糊半径，取值范围为1 - 50";
    radiusSlider.maximumValue = 50;
    [self.operationView addSubview:radiusSlider];
    [radiusSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(sigmaTitle.bottom).offset(8);
        make.height.equalTo(60);
        make.right.equalTo(0);
    }];
    self.radiusSlider = radiusSlider;

    
    CISlider *sigmaSlider = [CISlider new];
    sigmaSlider.titleString = @"正态分布的标准差，必须大于0";
    radiusSlider.maximumValue = 100;
    [self.operationView addSubview:sigmaSlider];
    [sigmaSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(radiusSlider.bottom).offset(8);
        make.height.equalTo(60);
        make.right.equalTo(0);
    }];
    self.sigmaSlider = sigmaSlider;
}

- (void)reset{
    
}

- (void)loadImage{
    CITransformation * tran = [CITransformation new];
    [tran setBlurRadius:self.radiusSlider.value sigma:self.sigmaSlider.value];
    [self loadData:self.selectImageIndex andTranform:tran];
}

@end
