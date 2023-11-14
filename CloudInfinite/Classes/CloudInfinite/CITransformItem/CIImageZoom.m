//
//  CIImageZoom.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIImageZoom.h"

@interface CIImageZoom ()

@property(nonatomic,assign)ScaleType scaleType;


@property(nonatomic,assign)ScalePercentType pScaleType;


@property(nonatomic,assign)CGSize thumbnailSize;


@property(nonatomic,assign)CGFloat percentScale;


@property(nonatomic,assign)CGFloat area;

@end

@implementation CIImageZoom

-(instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height scaleType:(ScaleType)type{
    
    if (self  == [super init]) {
        self.scaleType = type;
        self.thumbnailSize = CGSizeMake(width, height);
    }
    return self;
}

-(instancetype)initWithPercent:(CGFloat)percent scaleType:(ScalePercentType)type{
    
    if (self  == [super init]) {
        self.pScaleType = type;
        self.percentScale = percent;
    }
    return self;
}

-(instancetype)initWithArea:(CGFloat)area{
    if (self == [super init]) {
        self.area = area;
    }
    return self;
}

- (NSString *)buildPartUrl{
    NSString * partUrl;
    if (!CGSizeEqualToSize(self.thumbnailSize, CGSizeZero)) {
        if (self.scaleType == ScaleTypeAUTOFit) {
            partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/%.0fx%.0f",self.thumbnailSize.width,self.thumbnailSize.height];
            
        }else if (self.scaleType == ScaleTypeAUTOFITWithMin) {
            partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/!%.0fx%.0fr",self.thumbnailSize.width,self.thumbnailSize.height];
        }else if(self.scaleType == ScaleTypeAUTOFill){
            partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/%.0fx%.0f!",self.thumbnailSize.width,self.thumbnailSize.height];
        }else if (self.scaleType == ScaleTypeOnlyWidth){
            partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/%.0fx",self.thumbnailSize.width];
        }else if (self.scaleType == ScaleTypeOnlyHeight){
            partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/x%.0f",self.thumbnailSize.height];
        }
        
    }else if (self.pScaleType != 0) {
        if (self.pScaleType == ScalePercentTypeOnlyHeight) {
            partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/!x%.0fp",self.percentScale];
            
        }else if(self.pScaleType == ScalePercentTypeOnlyWidth){
            partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/!%.0fpx",self.percentScale];
            
        }else{
            partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/!%.0fp",self.percentScale];
        }
    }else if (self.area > 0) {
        partUrl = [NSString stringWithFormat:@"imageMogr2/thumbnail/%.0f",self.area];
    }
    return partUrl;
}

@end
