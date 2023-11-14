//
//  BaseViewController.h
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/12.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudInfinite.h>
#import "TPGCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import <UIImageView+CI.h>
#import <SDWebImage.h>
//#import <CIImageLoader.h>
#import <UIView+CI.h>
#import <UIButton+WebCache.h>
#import <SDWebImage-CloudInfinite.h>
#import <CISmartFaceTransformation.h>
#import <CIResponsiveTransformation.h>
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>
#import "CISlider.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic,strong)NSArray * urlArray;

@property(nonatomic,strong)NSString * imageURL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionImagesHeight;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property(nonatomic,assign)NSInteger selectImageIndex;
@property(nonatomic,strong)UIImage * currentImage;


/// 默认支持gif
@property(nonatomic,assign)BOOL notSupportGif;

-(UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

-(void)loadData:(NSInteger)index andTranform:(nullable CITransformation *)tran;

-(void)buildOperationView;

-(void)reset;

-(void)loadImage;

-(void)setImage:(UIImage * )image;
@end

NS_ASSUME_NONNULL_END
