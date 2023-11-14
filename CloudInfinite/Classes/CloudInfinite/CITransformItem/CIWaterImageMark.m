//
//  CIWaterImageMark.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//
//指定的水印图片必须同时满足如下3个条件：
//
//1:水印图片与源图片必须位于同一个存储桶下。
//2:URL 需使用 COS 域名（不能使用 CDN 加速域名，例如 examplebucket-1250000000.file.myqcloud.
//com/shuiyin_2.png 不可用 ），且需保证水印图可访问（如果水印图读取权限为私有，则需要携带有效签名）。
//
//3:URL 必须以http://开始，不能省略 HTTP 头，也不能填 HTTPS 头，例如examplebucket-1250000000.cos.ap-shanghai.
//myqcloud.com/shuiyin_2.png，https://examplebucket-1250000000.cos.ap-shanghai.myqcloud.com/shuiyin_2.png
//为非法的水印 URL。

#import "CIWaterImageMark.h"
#import "CloudInfiniteTools.h"

@interface CIWaterImageMark ()

@property(nonatomic,strong)NSString * imageMarkUrl;

@property(nonatomic,assign)CloudInfiniteGravity gravity;

@property(nonatomic,assign)CGFloat dx;

@property(nonatomic,assign)CGFloat dy;

@property(nonatomic,assign)CIWaterImageMarkBlogoEnum blogo;

@end

@implementation CIWaterImageMark

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                         gravity:(CloudInfiniteGravity)gravity
                              dx:(CGFloat)dx
                              dy:(CGFloat)dy
                          blogo:(CIWaterImageMarkBlogoEnum)blogo
{
    self = [super init];
    if (self) {
        _imageMarkUrl = imageUrl;
        _gravity = gravity;
        _dx = dx;
        _dy = dy;
        _blogo = blogo;
    }
    return self;
}

- (NSString *)buildPartUrl{
    
    if (_blogo == CIWaterImageMarkBlogoNone) {
        return [NSString stringWithFormat:@"watermark/1/image/%@/gravity/%@/dx/%.0f/dy/%.0f",[CloudInfiniteTools base64DecodeString:_imageMarkUrl],[CloudInfiniteTools gravityToString:_gravity],_dx,_dy];
    }else{
        return [NSString stringWithFormat:@"watermark/1/image/%@/gravity/%@/dx/%.0f/dy/%.0f/blogo/%ld",[CloudInfiniteTools base64DecodeString:_imageMarkUrl],[CloudInfiniteTools gravityToString:_gravity],_dx,_dy,_blogo];
    }
}

@end
