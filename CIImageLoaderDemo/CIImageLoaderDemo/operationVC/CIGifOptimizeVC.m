//
//  CIGifOptimizeVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/14.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIGifOptimizeVC.h"

@interface CIGifOptimizeVC ()
@property(nonatomic,strong)CISlider * cgifSlider;
@end

@implementation CIGifOptimizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionImagesHeight.constant = 120;
}

- (NSArray *)urlArray{
    return @[
        @"https://tpg-1253653367.file.myqcloud.com/dingdang.gif",
        @"https://tpg-1253653367.file.myqcloud.com/gif1.gif",
        @"https://tpg-1253653367.file.myqcloud.com/gif2.gif",
        @"https://tpg-1253653367.file.myqcloud.com/gif3.gif",
        @"https://tpg-1253653367.file.myqcloud.com/gif4.gif",
        @"https://tpg-1253653367.file.myqcloud.com/gif5.gif",
        @"https://tpg-1253653367.file.myqcloud.com/10.gif",
        @"https://tpg-1253653367.file.myqcloud.com/11.gif",
        @"https://tpg-1253653367.file.myqcloud.com/12.gif",
        @"https://tpg-1253653367.file.myqcloud.com/13.gif",
        @"https://tpg-1253653367.file.myqcloud.com/20.gif",
        @"https://tpg-1253653367.file.myqcloud.com/21.gif",
        @"https://tpg-1253653367.file.myqcloud.com/22.gif",
        @"https://tpg-1253653367.file.myqcloud.com/23.gif",
        @"https://tpg-1253653367.file.myqcloud.com/24.gif",
        @"https://tpg-1253653367.file.myqcloud.com/25.gif",
        @"https://tpg-1253653367.file.myqcloud.com/26.gif",
        @"https://tpg-1253653367.file.myqcloud.com/27.gif",
        @"https://tpg-1253653367.file.myqcloud.com/28.gif",
        @"https://tpg-1253653367.file.myqcloud.com/29.gif",
        @"https://tpg-1253653367.file.myqcloud.com/30.gif",
    ];
}

- (void)buildOperationView{
    [super buildOperationView];
    
    
    CISlider *cgifSlider = [CISlider new];
    
    [self.operationView addSubview:cgifSlider];
    cgifSlider.titleString = @"指定帧数";
    cgifSlider.maximumValue = 100;
    cgifSlider.minimumValue = 1;
    
    [cgifSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(self.operationView.top).offset(20);
        make.height.equalTo(60);
        make.right.equalTo(0);
    }];
    self.cgifSlider = cgifSlider;
    
    
    UILabel * sharpenTitle = [UILabel new];
    sharpenTitle.numberOfLines = 0;
    sharpenTitle.font = [UIFont systemFontOfSize:13];
    [self.operationView addSubview:sharpenTitle];
    [sharpenTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(cgifSlider.bottom).offset(16);
        make.right.equalTo(-16);
    }];
    sharpenTitle.text = @"gif 格式优化：只针对原图为 gif 格式，对 gif 图片格式进行的优化，降帧降颜色。分为以下两种情况：\n1: FrameNumber=1，则按照默认帧数30处理，如果图片帧数大于该帧数则截取。\n2:FrameNumber 取值( 1,100 ]，则将图片压缩到指定帧数 （FrameNumber）。";
}

- (void)loadImage{
    CITransformation * tran = [CITransformation new];
    [tran setCgif:self.cgifSlider.value];
    [self loadData:self.selectImageIndex andTranform:tran];
}

- (void)reset{
    
}

@end
