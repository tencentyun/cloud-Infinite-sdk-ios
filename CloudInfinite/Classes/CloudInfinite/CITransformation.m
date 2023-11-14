//
//  CITransformation.m
//  CloudInfinite
//
//  Created by garenwang on 2020/7/23.
//

#import "CITransformation.h"
#import "CIImageLoadRequest.h"

#import "CIImageChangeType.h"
#import "CIImageZoom.h"
#import "CIImageTailor.h"
#import "CIImageRotate.h"
#import "CIGaussianBlur.h"
#import "CIImageSharpen.h"
#import "CIWaterImageMark.h"
#import "CIQualityChange.h"
#import "CIImageStrip.h"


@interface CITransformation ()

@property(nonatomic,strong)NSMutableArray <id<CITransformActionProtocol>> * transformArrays;

@property(nonatomic,assign)BOOL autoSetAveColor;

@end

@implementation CITransformation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transformArrays = [NSMutableArray new];
        self.ignoreError = YES;
    }
    return self;
}

#pragma mark 格式转换
-(void)setFormatWith:(CIImageFormat)format{
    [self setFormatWith:format options:CILoadTypeAcceptHeader];
}

-(void)setFormatWith:(CIImageFormat)format options:(CILoadTypeEnum)options{
    CIImageChangeType * actionChangeType = [[CIImageChangeType alloc]initWithFormat:format options:options];
    [self.transformArrays addObject:actionChangeType];
}

-(void)setCgif:(NSInteger)cgif{
    CIImageChangeType * actionChangeType = [[CIImageChangeType  alloc]initWithCgif:cgif];
    [self.transformArrays addObject:actionChangeType];
}

-(void)setInterlace:(BOOL)interlace{
    CIImageChangeType * actionChangeType = [[CIImageChangeType  alloc]initWithInterlace:interlace];
    [self.transformArrays addObject:actionChangeType];
}

#pragma --mark 图片缩放

-(void)setZoomWithPercent:(CGFloat)percent scaleType:(ScalePercentType)type{
    CIImageZoom * actionZoom = [[CIImageZoom alloc]initWithPercent:percent scaleType:type];
    [self.transformArrays addObject:actionZoom];
}

-(void)setZoomWithWidth:(CGFloat)width height:(CGFloat)height scaleType:(ScaleType)type{
    CIImageZoom * actionZoom = [[CIImageZoom alloc]initWithWidth:width height:height scaleType:type];
    [self.transformArrays addObject:actionZoom];
}

-(void)setZoomWithArea:(CGFloat)area{
    CIImageZoom * actionZoom = [[CIImageZoom alloc]initWithArea:area];
    [self.transformArrays addObject:actionZoom];
}

#pragma --mark 图片剪裁

-(void)setCutWithWidth:(CGFloat)width height:(CGFloat)height dx:(CGFloat)x dy:(CGFloat)y{
    CIImageTailor * actionTailor = [[CIImageTailor alloc]initWithCut:width height:height dx:x dy:y];
    [self.transformArrays addObject:actionTailor];
}

-(void)setCutWithIRadius:(CGFloat)radius{
    CIImageTailor * actionTailor = [[CIImageTailor alloc]initWithIRadius:radius];
    [self.transformArrays addObject:actionTailor];
}

-(void)setCutWithRRadius:(CGFloat)radius{
    CIImageTailor * actionTailor = [[CIImageTailor alloc]initWithRRadius:radius];
    [self.transformArrays addObject:actionTailor];
}

-(void)setCutWithScrop:(CGFloat)width height:(CGFloat)height{
    CIImageTailor * actionTailor = [[CIImageTailor alloc]initWithScrop:width height:height];
    [self.transformArrays addObject:actionTailor];
}

-(void)setCutWithCrop:(CGFloat)width height:(CGFloat)height{
    CIImageTailor * actionTailor = [[CIImageTailor alloc]initWithCrop:width height:height gravity:CIGravityNone];
    [self.transformArrays addObject:actionTailor];
}

-(void)setCutWithCrop:(CGFloat)width height:(CGFloat)height gravity:(CloudInfiniteGravity)gravity{
    CIImageTailor * actionTailor = [[CIImageTailor alloc]initWithCrop:width height:height gravity:gravity];
    [self.transformArrays addObject:actionTailor];
}



#pragma --mark 图片旋转
-(void)setRotateWith:(CGFloat)degree{
    CIImageRotate * actionRotate = [[CIImageRotate alloc]initWithRotate:degree];
    [self.transformArrays addObject:actionRotate];
}

-(void)setRotateAutoOrient{
    CIImageRotate * actionRotate = [[CIImageRotate alloc]initWithAutoOrientWith:YES];
    [self.transformArrays addObject:actionRotate];
}

#pragma --mark 高斯模糊
-(void)setBlurRadius:(CGFloat)bRadius sigma:(CGFloat)sigma{
    CIGaussianBlur * actionBlur = [[CIGaussianBlur alloc]initWithBlurRadius:bRadius sigma:sigma];
    [self.transformArrays addObject:actionBlur];
}

#pragma --mark 锐化
- (void)setSharpenWith:(CGFloat)sharpen{
    CIImageSharpen * actionSharpen = [[CIImageSharpen alloc]initWithSharpe:sharpen];
    [self.transformArrays addObject:actionSharpen];
}

#pragma --mark 水印
- (void)setWaterMarkText:(NSString *)text
                    font:(UIFont * _Nullable)font
               textColor:(UIColor * _Nullable)color
                dissolve:(NSInteger)dissolve
                 gravity:(CloudInfiniteGravity)gravity
                      dx:(CGFloat)dx
                      dy:(CGFloat)dy
                   batch:(BOOL)batch
                  degree:(CGFloat)degree{
    CIWaterTextMark *actionTextMark = [[CIWaterTextMark alloc]initWithText:text font:font textColor:color dissolve:dissolve gravity:gravity dx:dx dy:dy batch:batch degree:degree];
    [self.transformArrays addObject:actionTextMark];
}

- (void)setWaterMarkWithImageUrl:(NSString *)imageUrl
                         gravity:(CloudInfiniteGravity)gravity
                              dx:(CGFloat)dx
                              dy:(CGFloat)dy
                           blogo:(CIWaterImageMarkBlogoEnum)blogo{
    CIWaterImageMark * actionImageMark = [[CIWaterImageMark alloc]initWithImageUrl:imageUrl gravity:gravity dx:dx dy:dy blogo:blogo];
    [self.transformArrays addObject:actionImageMark];
}

#pragma --mark 质量变换
- (void)setQualityWithQuality:(NSInteger)quality type:(CIQualityChangeEnum)type{
    CIQualityChange * actionQuality = [[CIQualityChange alloc]initWithQuality:quality type:type];
    [self.transformArrays addObject:actionQuality];
}

#pragma --mark 获取图片主色调
-(void)setViewBackgroudColorWithImageAveColor:(BOOL)autoSet{
    _autoSetAveColor = autoSet;
}

-(void)setImageStrip{
    CIImageStrip * actionStrip = [[CIImageStrip alloc]initStrip];
    [self.transformArrays addObject:actionStrip];
}
@end


