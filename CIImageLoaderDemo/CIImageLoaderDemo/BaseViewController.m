//
//  BaseViewController.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/12.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *tpgHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labType;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildOperationView];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData:0 andTranform:nil];
    
}


- (NSArray *)urlArray{
    if (self.notSupportGif) {
        return @[
            @"http://example-1258125638.cos.ap-shanghai.myqcloud.com/sample.png",
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
    }

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlArray.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TPGCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPGCollectionViewCell" forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[indexPath.row]] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.labTitle.text = [NSString stringWithFormat:@"大小:%.2lu KB", expectedSize / 1000];
        });
        
    } completed:nil];
    
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

-(void)loadData:(NSInteger)index andTranform:(nullable CITransformation *)tran{
    // SDWebImageRefreshCached 在请求图片是先回将缓存中的图片显示，同时也会请求图片，为了更直观，这里直接将缓存清除
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
    
    NSString * imageUrl = [self.urlArray objectAtIndex:index];
    self.imageURL = imageUrl;
    
    self.labTitle.text = @"大小：";
    
    self.labType.text = @"格式：";
    
    self.labTime.text = @"耗时：";
    
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();

    
    
    [self.imageView sd_CI_setImageWithURL:[NSURL URLWithString:imageUrl] transformation:tran completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (self.currentImage== nil) {
            self.currentImage = image;
        }
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        self.labTime.text = [NSString stringWithFormat:@"耗时：%.2f s",linkTime];
        
        [self showDataSizeUrl:imageURL typeLable:self.labType sizeLable:self.labTitle];
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
    
    
    NSString *numStr = [NSString stringWithFormat:@"%c%c%c",char1,char2,char3];
    return numStr;
}

-(UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];

    button .backgroundColor = [UIColor blueColor];
    return button;;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectImageIndex = indexPath.row;
    [self reset];
    [self loadData:indexPath.row andTranform:nil];
}

- (void)buildOperationView{
    UIButton * submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.operationView addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(35);
        make.bottom.equalTo(self.operationView.bottom).offset(-16);
    }];
    submit.backgroundColor = [UIColor blueColor];
    [submit setTitle:@"加载图片" forState:UIControlStateNormal];
    [submit addTarget:self  action:@selector(loadImage) forControlEvents:UIControlEventTouchUpInside];
}

-(void)loadImage{
    
}

- (void)reset{
    self.imageView.backgroundColor = [UIColor whiteColor];
}

-(void)setImage:(UIImage * )image{
    self.imageView.image = image;
}
@end
