//
//  CIQualityChangeVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/13.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIQualityChangeVC.h"

@interface CIQualityChangeVC ()

@property(nonatomic,strong)UILabel * titleLable;

@property(nonatomic,strong)UISegmentedControl * segment;

@property(nonatomic,strong)CISlider * slider;
@end

@implementation CIQualityChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)actionSegment:(UISegmentedControl *)segment{
    
    if (segment.selectedSegmentIndex == 0) {
        self.titleLable.text = @"图片的绝对质量，取值范围0 - 100 ，默认值为原图质量；取原图质量和指定质量的最小值；";
    }
    
    if (segment.selectedSegmentIndex == 1) {
        self.titleLable.text = @"图片的绝对质量，取值范围0 - 100 ，默认值为原图质量；取原图质量和指定质量的最小值；<Quality>后面加“!”表示强制使用指定值，例如：90!";
    }
    
    if (segment.selectedSegmentIndex == 2) {
        self.titleLable.text = @"图片的相对质量，取值范围0 - 100 ，数值以原图质量为标准。例如原图质量为80，将 rquality 设置为80后，得到处理结果图的图片质量为64（80x80%）。";
    }
    
    if (segment.selectedSegmentIndex == 3) {
        self.titleLable.text = @"图片的最低质量，取值范围0 - 100 ，设置结果图的质量参数最小值。例如原图质量为85，将 lquality 设置为80后，处理结果图的图片质量为85。例如原图质量为60，将 lquality 设置为80后，处理结果图的图片质量会被提升至80。";
    }
    [self.titleLable sizeToFit];
}


- (void)buildOperationView{
    [super buildOperationView];
    UISegmentedControl * segment = [[UISegmentedControl alloc]initWithItems:@[@"绝对质量变换",@"绝对质量变换-指定",@"相对质量变换",@"最低质量变换"]];
    [self.operationView addSubview:segment];
    [segment setSelectedSegmentIndex:0];
    
    self.segment = segment;
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(35);
        make.top.equalTo(self.operationView.top).offset(20);
    }];
    
    CISlider * slider = [CISlider new];
    [self.operationView addSubview:slider];
    self.slider = slider;
    self.slider.maximumValue = 100;
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(35);
        make.top.equalTo(segment.bottom).offset(20);
    }];
    
    self.titleLable = [UILabel new];
    [self.operationView addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(slider.bottom).offset(16);
        make.right.equalTo(-16);
    }];
    self.titleLable.numberOfLines = 0;
    self.titleLable.text = @"图片的绝对质量，取值范围0 - 100 ，默认值为原图质量；取原图质量和指定质量的最小值；";
    [self.titleLable sizeToFit];
    self.titleLable.font = [UIFont systemFontOfSize:15];
    [segment addTarget:self  action:@selector(actionSegment:) forControlEvents:UIControlEventValueChanged];
}


- (void)loadImage{
    CITransformation * tran = [CITransformation new];
    [tran setQualityWithQuality:self.slider.value * 100 type:(CIQualityChangeEnum)self.segment.selectedSegmentIndex + 1];
    [self loadData:self.selectImageIndex andTranform:tran];
}

- (void)reset{
    
}

@end
