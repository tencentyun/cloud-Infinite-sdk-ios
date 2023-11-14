//
//  CICutImageVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/12.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CICutImageVC.h"

@interface CICutImageVC ()

@property(nonatomic,strong)CISlider * dx;

@property(nonatomic,strong)CISlider * dy;

@property(nonatomic,strong)CISlider * width;

@property(nonatomic,strong)CISlider * height;

@property(nonatomic,assign)CGFloat dxNum;

@property(nonatomic,assign)CGFloat dyNum;

@property(nonatomic,assign)CGFloat widthNum;

@property(nonatomic,assign)CGFloat heightNum;

@property (nonatomic,strong)UISegmentedControl * segment;

@end

@implementation CICutImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)actionSelectCutType:(UISegmentedControl *)segment{
    [self loadData:0 andTranform:nil];
    [self reset];
    if (segment.selectedSegmentIndex == 0) {
        self.width.titleString = @"宽度：";
        self.width.hidden = NO;
        self.height.hidden = NO;
        self.dx.hidden = NO;
        self.dy.hidden = NO;
    }
    
    if (segment.selectedSegmentIndex == 1 || segment.selectedSegmentIndex == 4) {
        self.width.titleString = @"宽度：";
        self.width.hidden = NO;
        self.height.hidden = NO;
        self.dx.hidden = YES;
        self.dy.hidden = YES;
    }
    
    if (segment.selectedSegmentIndex == 2 || segment.selectedSegmentIndex == 3) {

        self.width.titleString = @"半径：";
        self.width.hidden = NO;
        self.height.hidden = YES;
        self.dx.hidden = YES;
        self.dy.hidden = YES;
    }
}



-(CISlider *)createSliderAndTitle:(NSInteger)index andTitle:(NSString *) title{
    
    CISlider * slider = [CISlider new];
    slider.titleString = title;
    [self.operationView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(index * 60 + 60);
        make.height.equalTo(60);
        make.width.equalTo(self.operationView.mas_width);
    }];
    slider.tag = 1000 + index;

    return slider;
};

- (void)buildOperationView{
    [super buildOperationView];
    UISegmentedControl * segment = [[UISegmentedControl alloc]initWithItems:@[@"普通裁剪",@"缩放裁剪",@"内切圆",@"圆角",@"人脸裁剪"]];
    segment.frame = CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 35);
    [self.operationView addSubview:segment];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self  action:@selector(actionSelectCutType:) forControlEvents:UIControlEventValueChanged];
    self.segment = segment;
    self.width = [self createSliderAndTitle:0 andTitle:@"宽度:"];
      
    self.height = [self createSliderAndTitle:1 andTitle:@"高度:"];
    
    self.dx = [self createSliderAndTitle:2 andTitle:@"dx:"];
    
    self.dy = [self createSliderAndTitle:3 andTitle:@"dy:"];
    
    
}

- (void)setCurrentImage:(UIImage *)currentImage{
    [super setCurrentImage:currentImage];
    if (currentImage != nil) {
        self.dx.maximumValue = self.currentImage.size.width;
        
        self.width.maximumValue = self.currentImage.size.width;
        
        self.dy.maximumValue = self.currentImage.size.height;
        
        self.height.maximumValue = self.currentImage.size.height;
    }
}

- (void)reset{
    self.dx.value = self.dy.value = self.width.value = self.height.value = 0;
}

- (void)loadImage{
    if (self.currentImage == nil) {
        return;
    }
    
    
    self.dxNum = self.dx.value;
    
    self.dyNum = self.dy.value;
    
    self.widthNum = self.width.value;
    
    self.heightNum = self.height.value;
    
    CITransformation * tran = [CITransformation new];
    
    if (self.segment.selectedSegmentIndex == 0) {
        [tran setCutWithWidth:self.widthNum height:self.heightNum dx:self.dxNum dy:self.dyNum];
    }else if (self.segment.selectedSegmentIndex == 1){
        [tran setCutWithCrop:self.widthNum height:self.heightNum];
    }else if (self.segment.selectedSegmentIndex == 2){
        [tran setCutWithIRadius:self.widthNum];
    }else if (self.segment.selectedSegmentIndex == 3){
        [tran setCutWithRRadius:self.widthNum];
    }else if (self.segment.selectedSegmentIndex == 4){
        [tran setCutWithScrop:self.widthNum height:self.heightNum];
    }
    [self loadData:self.selectImageIndex andTranform:tran];
}

@end
