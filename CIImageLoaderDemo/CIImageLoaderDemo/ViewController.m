//
//  ViewController.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/7/13.
//  Copyright © 2020 garenwang. All rights reserved.
//https://lns.hywly.com/a/1/8523/1.jpg

#import "ViewController.h"
#import <CloudInfinite.h>
#import "TPGCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import <UIImageView+CI.h>
#import <SDWebImage.h>
#import <CIImageLoader.h>
#import <UIButton+WebCache.h>
#import <SDWebImage-CloudInfinite.h>
#import <UIImageView+AVIF.h>
#import <UIImageView+TPG.h>
#import "UIImage+TPGDecode.h"
#import "UIImage+AVIFDecode.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSArray * urlArray;
@property (weak, nonatomic) IBOutlet UICollectionView *tpgHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *tpgImageView;
@property (weak, nonatomic) IBOutlet UILabel *labTpgTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labTPGTime;
@property (weak, nonatomic) IBOutlet UILabel *labType;
@property (weak, nonatomic) IBOutlet UILabel *labTPGType;

@end


@implementation ViewController

- (NSArray *)urlArray{
    
    if (self.format == CIImageTypeTPG) {
        return @[
            @"https://assets-football.hoopchina.com.cn/football/teamLogo/1017132305849778176.png",
            @"https://assets-football.hoopchina.com.cn/football/teamLogo/1023292959778406400.png",
            @"https://assets-football.hoopchina.com.cn/football/teamLogo/1024742413534494720.png",
            @"http://example-1258125638.cos.ap-shanghai.myqcloud.com/sample.png",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/01.gif",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default01.jpg",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default02.jpg",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default03.jpg",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default04.jpg",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default05.png",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default06.png",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default07.png",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default08.png"
        ];
    }else{
        return @[
            @"https://assets-football.hoopchina.com.cn/football/teamLogo/1017132305849778176.png",
            @"https://assets-football.hoopchina.com.cn/football/teamLogo/1023292959778406400.png",
            @"https://assets-football.hoopchina.com.cn/football/teamLogo/1024742413534494720.png",
            @"http://example-1258125638.cos.ap-shanghai.myqcloud.com/sample.png",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/01.gif",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default01.jpg",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default02.jpg",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default03.jpg",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default04.jpg",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default05.png?imageMogr2/format/avif",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default06.png",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default07.png",
            @"https://tpgdemo-1253960454.cos.ap-guangzhou.myqcloud.com/default08.png"
        ];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.tpgHeader registerNib:[UINib nibWithNibName:@"TPGCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TPGCollectionViewCell"];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(90, 90);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    [self.tpgHeader setCollectionViewLayout:layout];
    self.tpgHeader.delegate = self;
    self.tpgHeader.dataSource = self;
    [self.tpgHeader reloadData];
    self.tpgHeader.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:imageView];
    
    [self loadData:0];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlArray.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPGCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPGCollectionViewCell" forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[indexPath.row]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self showDataSizeUrl:imageURL typeLable:nil sizeLable:cell.labTitle];
    }];
    
    return cell;
}

-(void)showDataSizeUrl:(NSURL *)imageURL typeLable:(UILabel *)typeLable sizeLable:(UILabel *)sizeLable{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // sdwebimage 没有返回image data数据，用这个方式单独获取data，显示文件格式以及大小，正常使用时无需此步骤
        NSData * data = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            typeLable.text = [NSString stringWithFormat:@"格式：%@",[self getImageType:data]];
            sizeLable.text = [NSString stringWithFormat:@"大小:%.2lu KB", [data length] / 1000];
        });
    });
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self loadData:indexPath.row];
}

-(void)loadData:(NSInteger)index{
    // SDWebImageRefreshCached 在请求图片是先回将缓存中的图片显示，同时也会请求图片，为了更直观，这里直接将缓存清除
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
    
    NSString * imageUrl = [self.urlArray objectAtIndex:index];
    self.labTitle.text = @"大小：";
    self.labTpgTitle.text = @"大小：";
    self.labType.text = @"格式：";
    self.labTPGType.text = @"格式：";
    self.labTime.text = @"耗时：";
    self.labTPGTime.text = @"耗时：";
    
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        self.labTime.text = [NSString stringWithFormat:@"耗时：%.2f s",linkTime];
        
        [self showDataSizeUrl:imageURL typeLable:self.labType sizeLable:self.labTitle];
    }];
    
    CITransformation * tran;
    
    if (self.format == CIImageTypeTPG) {
        tran = [CITransformation new];
        [tran setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
    }else if(self.format == CIImageTypeAUTO){
        tran = [[CIResponsiveTransformation alloc]initWithView:self.imageView scaleType:ScaleTypeAUTOFit];
    }else if(self.format == CIImageTypeWEBP){
        tran = [CITransformation new];
        [tran setFormatWith:CIImageTypeWEBP options:CILoadTypeUrlFooter];
    }else if(self.format == CIImageTypeAVIF){
        tran = [CITransformation new];
        [tran setFormatWith:CIImageTypeAVIF options:CILoadTypeUrlFooter];
    }
    
    //    ***************缩放*************
    //    [tran setZoomWithPercent:50 scaleType:ScalePercentTypeOnlyWidth];
    //    [tran setZoomWithPercent:50 scaleType:ScalePercentTypeOnlyHeight];
    //    [tran setZoomWithPercent:50 scaleType:ScalePercentTypeALL];
    //    [tran setZoomWithWidth:self.tpgImageView.frame.size.width height:self.tpgImageView.frame.size.height scaleType:ScaleTypeAUTOFit];
    //    [tran setZoomResponsiveWith:self.tpgImageView scaleType:ScaleTypeAUTOFIT];
    //    [tran setZoomWithArea:1000];
    
    //    ***************水印*************
    //    [tran setWaterMarkText:@"腾讯云·万象优图" font:nil textColor:nil dissolve:0 gravity:CIGravitySouth dx:100 dy:100 batch:YES degree:45];
    //    [tran setWaterMarkWithImageUrl:@"http://tpg-1253653367.cos.ap-guangzhou.myqcloud.com/google.jpg" gravity:0 dx:0 dy:0 blogo:0];
    //    ***************格式转换*************
    //    [tran setFormatWith:CIImageTypeTPG options:CILoadTypeUrlFooter];
    //    [tran setFormatWith:CIImageTypeTPG];
    //    [tran setCgif:199];
    //    [tran setInterlace:YES];
    
    //    ***************裁剪*************
    //    [tran setCutWithWidth:100 height:100 dx:30 dy:30];
    //    [tran setCutWithRRadius:100];
    //    [tran setCutWithIRadius:100];
    //    [tran setCutWithCrop:100 height:100];
    //    [tran setCutWithScrop:10 height:10]; //没试出来
    
    //    ***************旋转*************
    //    [tran setRotateWith:45];
    //    [tran setRotateAutoOrient];
    
    
    //    ***************高斯模糊*************
    //    [tran setBlurRadius:20 sigma:20];
    
    //    ***************锐化*************
    //    [tran setSharpenWith:10];
    
    //    ***************质量变换*************
    //    [tran setQualityWithQuality:60 type:CIQualityChangeAbsoluteFix];
    //    [tran setQualityWithQuality:60 type:CIQualityChangeAbsolute];
    //    [tran setQualityWithQuality:60 type:CIQualityChangeLowest];
    //    [tran setQualityWithQuality:60 type:CIQualityChangeRelative];
    
    //    ***************获取图片主题色*************
    //    [tran setViewBackgroudColorWithImageAveColor:YES];
    
    //    ***************去除元信息*************
    //    [tran setImageStrip];
    
    //    SmartFaceTransformation * tran = [[SmartFaceTransformation alloc]initWithView:self.tpgImageView];
    //    [tran setWaterMarkText:@"腾讯云·万象优图" font:nil textColor:nil dissolve:0 gravity:CIGravitySouth dx:100 dy:100 batch:YES degree:45];
    //    //    ResponsiveTransformation * tran = [[ResponsiveTransformation alloc]initWithView:self.tpgImageView scaleType:ScaleTypeAUTOFIT];
    //
    //
    [self.tpgImageView sd_CI_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:0 transformation:tran progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        self.labTPGTime.text = [NSString stringWithFormat:@"耗时：%.2f s",linkTime];
        [self showDataSizeUrl:imageURL typeLable:self.labTPGType sizeLable:self.labTpgTitle];
    }];

}



-(NSString *)getImageType:(NSData *)data{
    
    NSString * avifStr = @"";
    if (data.length > 15) {
        for (int i = 4; i <= 13; i ++) {
            char char1 = 0;
            [data getBytes:&char1 range:NSMakeRange(i, 1)];
            avifStr = [avifStr stringByAppendingString:[NSString stringWithFormat:@"%c",char1]];
        }
        if ([avifStr isEqualToString:@"ftypavif"] || [avifStr isEqualToString:@"ftypavis"]) {
            return avifStr;
        }
    }
    
    uint8_t ch;
    [data getBytes:&ch length:1];
    
    if (ch == 0xFF) {
        return  @"JPG";
    }
    if (ch == 0x89) {
        return @"PNG";
    }
    
    char char1 = 0 ;char char2 =0 ;char char3 = 0;
    
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    
    
    [data getBytes:&char2 range:NSMakeRange(1, 1)];
    
    [data getBytes:&char3 range:NSMakeRange(2, 1)];
    
    if (char1 == '\0' && char2 == '\0') {
        return @"HEIC";
    }

    
    
    NSString *numStr = [NSString stringWithFormat:@"%c%c%c",char1,char2,char3];
    return numStr;
}
@end


















