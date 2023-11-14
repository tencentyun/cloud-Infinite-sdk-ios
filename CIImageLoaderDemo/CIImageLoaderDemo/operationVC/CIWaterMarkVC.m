//
//  CIWaterMarkVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/13.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIWaterMarkVC.h"

@interface CIWaterMarkVC ()
@property(nonatomic,strong)UISegmentedControl * segment;
@end

@implementation CIWaterMarkVC

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (NSArray *)urlArray{
    return @[@"http://example-1258125638.cos.ap-shanghai.myqcloud.com/sample.png"];
}

- (void)reset{
    
}

- (void)loadImage{
    CITransformation * tran = [CITransformation new];
    if (self.segment.selectedSegmentIndex == 0) {
        [tran setWaterMarkWithImageUrl:@"http://tpg-1253653367.cos.ap-guangzhou.myqcloud.com/google.jpg" gravity:0 dx:0 dy:0 blogo:0];
    }else{
        [tran setWaterMarkText:@"腾讯云·万象优图" font:nil textColor:nil dissolve:0 gravity:CIGravitySouth dx:100 dy:100 batch:YES degree:45];
    }
    [self loadData:0 andTranform:tran];
}

- (void)buildOperationView{
    [super buildOperationView];
    UISegmentedControl * segment = [[UISegmentedControl alloc]initWithItems:@[@"图片水印",@"文字水印"]];
    [self.operationView addSubview:segment];
    [segment setSelectedSegmentIndex:0];
    
    self.segment = segment;
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(35);
        make.top.equalTo(self.operationView.top).offset(20);
    }];
    
    UILabel * labText = [UILabel new];
    labText.text = @"提示：\n水印功能参数较多，详细设置以及说明见代码以及注释；\n此处及展示示例";
    [self.operationView addSubview:labText];
    labText.numberOfLines = 0;
    [labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(self.segment.bottom).offset(20);
        make.height.equalTo(100);
    }];
}

@end
