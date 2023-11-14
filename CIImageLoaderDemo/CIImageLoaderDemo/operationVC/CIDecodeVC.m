//
//  CIDecodeVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/14.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIDecodeVC.h"
#import "UIImage+TPGDecode.h"
#import "UIImage+AVIFDecode.h"
#import "CIImageLoader.h"

@interface CIDecodeVC ()
@property (nonatomic,strong)CISlider * xSlider;
@property (nonatomic,strong)CISlider * ySlider;
@property (nonatomic,strong)CISlider * widthSlider;
@property (nonatomic,strong)CISlider * heightSlider;
@property (nonatomic,strong)CISlider * scanlySlider;

@property (nonatomic,assign)CGSize orginalImageSize;
@end

@implementation CIDecodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"解码测试";
    self.collectionImagesHeight.constant = 120;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CITransformation * tran = [CITransformation new];
    [tran setFormatWith:self.format];
    [self loadData:self.selectImageIndex andTranform:tran];
}

-(void)setupSlierValue{
    self.xSlider.maximumValue = self.orginalImageSize.width;
    self.ySlider.maximumValue = self.orginalImageSize.height;
    self.widthSlider.maximumValue = self.orginalImageSize.width;
    self.heightSlider.maximumValue = self.orginalImageSize.height;
    self.xSlider.value = self.ySlider.value = 0;
}

- (void)buildOperationView{
    [super buildOperationView];
      self.xSlider = [CISlider new];
      [self.operationView addSubview:self.xSlider];
    self.xSlider.titleString = @"x";
      [self.xSlider makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(16);
          make.top.equalTo(self.operationView.top).offset(0);
          make.height.equalTo(60);
          make.right.equalTo(-16);
      }];
    
    self.ySlider = [CISlider new];
    self.ySlider.titleString = @"y";
    [self.operationView addSubview:self.ySlider];
    [self.ySlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.xSlider.bottom).offset(0);
        make.height.equalTo(60);
        make.right.equalTo(-16);
    }];
    
    self.widthSlider = [CISlider new];
    self.widthSlider.titleString = @"width";
    [self.operationView addSubview:self.widthSlider];
    [self.widthSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.ySlider.bottom).offset(0);
        make.height.equalTo(60);
        make.right.equalTo(-16);
    }];
    
    self.heightSlider = [CISlider new];
    self.heightSlider.titleString = @"height";
    [self.operationView addSubview:self.heightSlider];
    [self.heightSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.widthSlider.bottom).offset(0);
        make.height.equalTo(60);
        make.right.equalTo(-16);
    }];
    
    self.scanlySlider = [CISlider new];
    self.scanlySlider.titleString = @"缩放因子";
    [self.operationView addSubview:self.scanlySlider];
    self.scanlySlider.maximumValue = 10;
    self.scanlySlider.minimumValue = 1;
    [self.scanlySlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.heightSlider.bottom).offset(0);
        make.height.equalTo(60);
        make.right.equalTo(-16);
    }];
}

-(void)loadData:(NSInteger)index andTranform:(CITransformation *)tran{
    
    self.xSlider.value = 0;
    self.ySlider.value = 0;
    self.widthSlider.value = 0;
    self.heightSlider.value = 0;
    self.scanlySlider.value = 0;
    
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:self.format options:CILoadTypeUrlFooter];
    [cloudInfinite requestWithBaseUrl:[self.urlArray objectAtIndex:index] transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            UIImage * image;
            if (self.format == CIImageTypeTPG) {
                image = [UIImage TPGImageWithContentsOfData:data];
                self.orginalImageSize = image.size;
            }else if (self.format == CIImageTypeAVIF){
                image = [UIImage AVIFImageWithContentsOfData:data];
                self.orginalImageSize = image.size;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupSlierValue];
                [self setImage:image];
            });
        }];
    }];
}

- (void)loadImage{
    
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [CITransformation new];
    [transform setFormatWith:self.format options:CILoadTypeUrlFooter];
    [cloudInfinite requestWithBaseUrl:[self.urlArray objectAtIndex:self.selectImageIndex] transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        [[CIImageLoader shareLoader] loadData:request loadComplete:^(NSData * _Nullable data, NSError * _Nullable error) {
            UIImage * image;
            if (self.format == CIImageTypeTPG) {
                image = [UIImage TPGImageWithContentsOfData:data scale:self.scanlySlider.value rect:CGRectMake(floor(self.xSlider.value), floor(self.ySlider.value), floor(self.widthSlider.value), floor(self.heightSlider.value))];
                
            }else if (self.format == CIImageTypeAVIF){
                image = [UIImage AVIFImageWithContentsOfData:data scale:self.scanlySlider.value rect:CGRectMake(floor(self.xSlider.value), floor(self.ySlider.value), floor(self.widthSlider.value), floor(self.heightSlider.value))];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:image];
            });
        }];
    }];
    
}



@end
