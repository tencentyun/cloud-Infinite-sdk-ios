//
//  CIRoTateVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/14.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIRoTateVC.h"

@interface CIRoTateVC ()
@property (nonatomic,strong)CISlider * slider;
@end

@implementation CIRoTateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionImagesHeight.constant = 120;
}


- (void)buildOperationView{
    [super buildOperationView];
    
    CISlider *slider = [CISlider new];
    self.slider = slider;
    slider.titleString = @"普通旋转：图片顺时针旋转角度，取值范围0 - 360";
    [self.operationView addSubview:slider];
    [slider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.operationView.top).offset(20);
        make.height.equalTo(100);
        make.right.equalTo(-16);
    }];
    slider.maximumValue = 360;
    
}

-(void)loadImage{
    CITransformation * tran = [CITransformation new];
    [tran setRotateWith:self.slider.value];
    [self loadData:self.selectImageIndex andTranform:tran];
}

@end
