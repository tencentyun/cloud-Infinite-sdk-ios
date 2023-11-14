//
//  CISharpenVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/14.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CISharpenVC.h"

@interface CISharpenVC ()
@property (nonatomic,strong)CISlider * sharpenSlider;
@end

@implementation CISharpenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionImagesHeight.constant = 120;
}

- (void)buildOperationView{
    [super buildOperationView];
    UILabel * sharpenTitle = [UILabel new];
      
      [self.operationView addSubview:sharpenTitle];
      [sharpenTitle mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(16);
          make.top.equalTo(self.operationView.top).offset(16);
          make.height.equalTo(40);
          make.right.equalTo(-16);
      }];
      sharpenTitle.text = @"2:锐化功能，取值范围为10 - 300间的整数。";
      
      sharpenTitle.numberOfLines = 2;
      CISlider *sharpenSlider = [CISlider new];
      sharpenSlider.maximumValue = 300;
      [self.operationView addSubview:sharpenSlider];
      [sharpenSlider makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(16);
          make.top.equalTo(sharpenTitle.bottom).offset(16);
          make.height.equalTo(35);
          make.right.equalTo(-16);
      }];
      self.sharpenSlider = sharpenSlider;
}

- (void)loadImage{
    CITransformation * tran = [CITransformation new];
    [tran setSharpenWith:self.sharpenSlider.value];
    [self loadData:self.selectImageIndex andTranform:tran];
}

@end
