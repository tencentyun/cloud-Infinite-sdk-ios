//
//  CIZoomImageVC.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/12.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIImageListTestVC.h"
#import "CISlider.h"
#import "CIImageLoader.h"
#import "UIImage+TPGDecode.h"
#import "TPGDecoderHelper.h"
@interface CIImageListTestVC ()

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)CISlider * width;

@property(nonatomic,strong)CISlider * height;

@property(nonatomic,strong)UISegmentedControl * segment;
@property(nonatomic,strong)UISegmentedControl * segmentSubType;

@end

@implementation CIImageListTestVC


- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.width / 2);
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TPGCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TPGCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView reloadData];
    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlArray.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPGCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPGCollectionViewCell" forIndexPath:indexPath];
    CITransformation *tran = [[CIResponsiveTransformation alloc]init];
    if (self.format != -1) {
        [tran setFormatWith:self.format options:CILoadTypeUrlFooter];
    }
//    [tran setViewBackgroudColorWithImageAveColor:YES];
//    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
    [cell.imageView sd_CI_setImageWithURL:[NSURL URLWithString:self.urlArray[indexPath.row]] transformation:tran];
    
    return cell;
}

- (NSArray *)urlArray{
    return @[
//        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/big_gif/12_8.gif",
//        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/big_gif/14_6.gif",
//        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/big_gif/18_5.gif",
//        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/big_gif/21_3.gif",
//        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/big_gif/24_9.gif",
//        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/big_gif/25_1.gif",
        @"http://examples-1251000004.cos.ap-shanghai.myqcloud.com/sample.jpeg",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/1024742413534494720.png",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/horizontal.jpg",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/vertical.jpg",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/01.gif",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/1017132305849778176.png",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/default02.jpg",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/default03.jpg",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/default04.jpg",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/default05.png",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/1023292959778406400.png",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/default06.png",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/default07.png",
        @"https://mobile-ut-1253960454.cos.ap-guangzhou.myqcloud.com/ci_image_sdk/default08.png",
    ];
}




@end
