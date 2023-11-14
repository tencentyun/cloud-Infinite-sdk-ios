//
//  CIStripImageVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/13.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIStripImageVC.h"

@interface CIStripImageVC ()
@property(nonatomic,strong)UISwitch * switchView;
@end

@implementation CIStripImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionImagesHeight.constant = 120;
}

- (void)buildOperationView{
    [super buildOperationView];
    
    
    UILabel * stripTitle = [UILabel new];
    [self.operationView addSubview:stripTitle];
    [stripTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(20);
        make.height.equalTo(40);
        make.right.equalTo(-16);
    }];
    stripTitle.text = @"去除图片元信息，包括 exif 信息";
    
    _switchView = [UISwitch new];
    [self.operationView addSubview:_switchView];
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(stripTitle.bottom).offset(16);
    }];
    
}

- (void)loadImage{
    CITransformation * tran = [CITransformation new];
    [tran setImageStrip];
    [self loadData:self.selectImageIndex andTranform:tran];
}

-(void)reset{
    
}

@end
