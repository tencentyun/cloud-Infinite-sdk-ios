//
//  GetAveColorVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/12.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "GetAveColorVC.h"

@interface GetAveColorVC (){
    UIView * colorView;
}

@property(nonatomic,strong)UISwitch * switchView;
@property (nonatomic,strong)UIButton * getAveColor;
@end

@implementation GetAveColorVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionImagesHeight.constant = 120;
}


-(void)actionGetAveColor:(UIButton *)sender{
    [colorView sd_CI_preloadWithAveColor:self.imageURL completed:^(UIColor * _Nonnull color) {
        self->colorView.backgroundColor = color;
    }];
}

-(void)buildOperationView{
    [super buildOperationView];
    
    UIView *view = [UIView new];
   
       colorView = view;
       [self.operationView addSubview:colorView];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(16);
           make.top.equalTo(20);
           make.height.equalTo(40);
           make.width.equalTo(40);
       }];
    
    UIButton * getAveColor = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.operationView addSubview:getAveColor];
    [getAveColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(view.bottom).offset(16);
        make.height.equalTo(35);
        make.right.equalTo(-16);
    }];
    [getAveColor addTarget:self  action:@selector(actionGetAveColor:) forControlEvents:UIControlEventTouchUpInside];
    [getAveColor setTitle:@"获取主题色" forState:UIControlStateNormal];
    getAveColor.backgroundColor = [UIColor blueColor];
    getAveColor.tag = 100;
    self.getAveColor = getAveColor;
    
   
    
    UILabel * aveTitle = [UILabel new];
    [self.operationView addSubview:aveTitle];
    [aveTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(getAveColor.bottom).offset(10);
        make.height.equalTo(60);
        make.right.equalTo(-16);
    }];
    aveTitle.text = @"加载图片同时，获取图片主题色设置给imageview控件作为背景色";
    aveTitle.numberOfLines = 2;
    
    _switchView = [UISwitch new];
    [self.operationView addSubview:_switchView];
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(aveTitle.bottom).offset(8);
    }];
    
}

- (void)loadImage{
    CITransformation * tran = [[CITransformation alloc]init];
    [tran setViewBackgroudColorWithImageAveColor:self.switchView.on];
    [self loadData:self.selectImageIndex andTranform:tran];
    [self reset];
}


-(void)reset{
    [super reset];
    colorView.backgroundColor = [UIColor whiteColor];
}

@end
