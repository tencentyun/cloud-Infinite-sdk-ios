//
//  CloudInfiniteEnum.h
//  Pods
//
//  Created by garenwang on 2020/8/11.
//CloudInfiniteGravity

#ifndef CloudInfiniteEnum_h
#define CloudInfiniteEnum_h

// 九宫格方位图可为图片的多种操作提供位置参考。红点为各区域位置的原点（通过 gravity 参数选定各区域后位移操作会以相应远点为参照）。
// 详情：https://cloud.tencent.com/document/product/460/6930
typedef NS_ENUM(NSUInteger, CloudInfiniteGravity) {
    CIGravityNone = 0,
    CIGravityNorthWest = 1,
    CIGravityNorth,
    CIGravityNorthEast,
    CIGravityWest,
    CIGravityEast,
    CIGravityCenter,
    CIGravitySouthWest,
    CIGravitySouth,
    CIGravitySouthEast,
};

    // 水印图适配功能，适用于水印图尺寸过大的场景（如水印墙）。共有两种类型：
typedef NS_ENUM(NSUInteger, CIWaterImageMarkBlogoEnum) {
    
    CIWaterImageMarkBlogoNone = 0,
    // 当 blogo 设置为1时，水印图会被缩放至与原图相似大小后添加
    CIWaterImageMarkBlogoTYPE_1 = 1,
    
    // 当 blogo 设置为2时，水印图会被直接裁剪至与原图相似大小后添加
    CIWaterImageMarkBlogoTYPE_2 = 2,
};

typedef NS_ENUM(NSUInteger, CIQualityChangeEnum) {
    
    // 图片的绝对质量，取值范围0 - 100 ，默认值为原图质量；
    CIQualityChangeAbsolute = 1,
    
    // 图片的绝对质量，取值范围0 - 100 ，强制使用指定值，例如：90!。
    CIQualityChangeAbsoluteFix,
    
    // 图片的相对质量，取值范围0 - 100 ，数值以原图质量为标准。例如原图质量为80，将 rquality 设置为80后，得到处理结果图的图片质量为64（80x80%）
    CIQualityChangeRelative,
    
    // 图片的最低质量，取值范围0 - 100 ，设置结果图的质量参数最小值。
    // 例如原图质量为85，将 lquality 设置为80后，处理结果图的图片质量为85。
    // 例如原图质量为60，将 lquality 设置为80后，处理结果图的图片质量会被提升至80。
    CIQualityChangeLowest,
};

typedef NS_ENUM(NSUInteger, ScaleType) {
    // 无
    ScaleTypeNone = 0,
    // 忽略原图宽高比例，指定图片宽度为 Width，高度为 Height ，强行缩放图片，可能导致目标图片变形
    ScaleTypeAUTOFill = 1,
    
    // 限定缩略图的宽度和高度的最大值分别为 Width 和 Height，进行等比缩放
    ScaleTypeAUTOFit,
    
    // 限定缩略图的宽度和高度的最小值分别为 Width 和 Height，进行等比缩放
    ScaleTypeAUTOFITWithMin,
    
    //指定目标图片宽度为 Width，高度传入0， 高度等比压缩
    ScaleTypeOnlyWidth,
    
    //指定目标图片高度为 Height，宽度传0，宽度等比压缩
    ScaleTypeOnlyHeight
};

typedef NS_ENUM(NSUInteger, ScalePercentType) {
    
    // 仅缩放宽度，高度不变
    ScalePercentTypeOnlyWidth = 1,
    
    // 仅缩放高度，宽度不变
    ScalePercentTypeOnlyHeight,
    
    //指定图片的宽高同时缩放
    ScalePercentTypeALL,
};


//请求tpg图时高级选项
typedef NS_OPTIONS(NSUInteger,CILoadTypeEnum){

    // 加载类型 方式一：带 accept 头部 accept:image/ ***
    CILoadTypeAcceptHeader = 0,
    
    // 加载类型 方式二：在 url 后面中拼接 imageMogr2/format/ ***
    // 如果需要方式二，则使用该值；不传默认为第一种方式
    CILoadTypeUrlFooter,
};

typedef NS_ENUM(NSUInteger,CIImageFormat) {
    CIImageTypeAUTO = 1,
    CIImageTypeTPG,
    CIImageTypePNG,
    CIImageTypeJPG,
    CIImageTypeBMP,
    CIImageTypeGIF,
    CIImageTypeHEIC,
    CIImageTypeWEBP,
    CIImageTypeYJPEG,
    CIImageTypeAVIF,
} ;


#endif /* CloudInfiniteEnum_h */
