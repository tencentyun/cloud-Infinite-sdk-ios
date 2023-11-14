//
//  CIFormatVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/12.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIFormatVC.h"
#import <CloudInfiniteTools.h>

@interface CIFormatVC ()

@property (nonatomic,strong)UISegmentedControl * segment;

@property(nonatomic,strong)UILabel * rotateTitle;

@property(nonatomic,strong)UISwitch * switchView;

@end

@implementation CIFormatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionImagesHeight.constant = 120;
    // Do any additional setup after loading the view.
}

-(void)actionImageTypeChange:(UISegmentedControl *)segment{
    
}

-(void)actionRotate:(CISlider *)slider{
    
}


- (void)buildOperationView{
    [super buildOperationView];
    // 格式转换
    UILabel * title = [UILabel new];
    [self.operationView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(10);
        make.height.equalTo(20);
        make.width.equalTo(200);
    }];
    
    title.text = @"1:格式转换";
//    webp 格式集成好了，跟TPG 类似；默认不依赖SDWebImageWebPCoder;
//    如果有使用到webp ,提示需要依赖；
//    使用时，不需要做在配其他的，
    
    UISegmentedControl * segment = [[UISegmentedControl alloc] initWithItems:@[@"TPG",@"PNG",@"JPG",@"BMP",@"GIF",@"HEIC",@"WEBP",@"YJPEG",@"AVIF"]];;
    [self.operationView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(4);
        make.right.equalTo(-4);
        make.top.equalTo(title.bottom).offset(10);
        make.height.equalTo(35);
    }];
    [segment addTarget:self  action:@selector(actionImageTypeChange:) forControlEvents:UIControlEventValueChanged];
    self.segment = segment;
    
    
    UILabel * stripTitle = [UILabel new];
    [self.operationView addSubview:stripTitle];
    stripTitle.numberOfLines = 0;
    [stripTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(segment.bottom).offset(10);
        make.right.equalTo(-16);
    }];
    stripTitle.text = @"2：输出为渐进式 jpg 格式。Mode 可为0或1。\n\t0：表示不开启渐进式；\n\t1：表示开启渐进式。\n注意：该参数仅在输出图片格式为 jpg 格式时有效。如果输出非 jpg 图片格式，会忽略该参数，默认值0";
    stripTitle.font = [UIFont systemFontOfSize:13];
    _switchView = [UISwitch new];
    [self.operationView addSubview:_switchView];
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(stripTitle.bottom).offset(16);
    }];
    
}

- (void)reset{
    
}

-(void)loadImage{
    CITransformation * tran = [CITransformation new];
    
    [tran setInterlace:self.switchView.on];
    CGFloat version = [[UIDevice currentDevice].systemVersion doubleValue];
    if ((self.segment.selectedSegmentIndex + 2) == CIImageTypeHEIC) {
        if (version >= 11.0) {
            [tran setFormatWith:(CIImageFormat) (self.segment.selectedSegmentIndex + 2) options:CILoadTypeUrlFooter];
        }
    }else{
        [tran setFormatWith:(CIImageFormat) (self.segment.selectedSegmentIndex + 2) options:CILoadTypeUrlFooter];
    }
    
    [self loadData:self.selectImageIndex andTranform:tran];
}


@end

