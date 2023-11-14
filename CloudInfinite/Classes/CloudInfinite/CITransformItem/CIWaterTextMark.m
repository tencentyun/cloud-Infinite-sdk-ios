//
//  CIWaterTextMark.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/10.
//

#import "CIWaterTextMark.h"
#import "CloudInfiniteTools.h"

@interface CIWaterTextMark()

/// 水印内容，需要经过 URL 安全的 Base64 编码
@property(nonatomic,strong)NSString *text;

/// 水印字体，需要经过 URL 安全的 Base64 编码，默认值 tahoma.ttf 。水印字体列表参考 支持字体列表
@property(nonatomic,strong)UIFont *font;

/// 水印文字字体大小，单位为磅，缺省值13
@property(nonatomic,assign)NSInteger fontsize;

/// 字体颜色，缺省为灰色，需设置为十六进制 RGB 格式（如 #FF0000），详情参考 RGB 编码表，需经过 URL 安全的 Base64 编码，默认值为 #3D3D3D
@property(nonatomic,strong)UIColor * textColor;

/// 文字透明度，取值1 - 100 ，默认90（完全不透明）
@property(nonatomic,assign)NSInteger dissolve;

/// 文字水印位置，九宫格位置（参见九宫格方位图），默认值 SouthEast
@property(nonatomic,assign)CloudInfiniteGravity gravity;

/// 水平（横轴）边距，单位为像素，缺省值为0
@property(nonatomic,assign)CGFloat dx;

/// 垂直（纵轴）边距，单位为像素，默认值为0
@property(nonatomic,assign)CGFloat dy;

/// 平铺水印功能，可将文字水印平铺至整张图片。当 batch 设置为1时，开启平铺水印功能
@property(nonatomic,assign)BOOL batch;

/// 文字水印的旋转角度设置，取值范围为0 - 360，默认0
@property(nonatomic,assign)NSInteger degree;
@end

@implementation CIWaterTextMark

- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)color
                    dissolve:(NSInteger)dissolve
                     gravity:(CloudInfiniteGravity)gravity
                          dx:(CGFloat)dx
                          dy:(CGFloat)dy
                       batch:(BOOL)batch
                      degree:(NSInteger)degree{
    if (self  == [super init]) {
        
        self.text = text;
        self.font = font;
        self.fontsize = font.pointSize;
        self.textColor = color;
        self.dissolve = dissolve;
        self.gravity = gravity;
        self.dx = dx;
        self.dy = dy;
        self.batch = batch;
        self.degree = degree;
    }
    return self;
}


- (NSString *)textBase64{
    if (_text == nil) {
        return @"";
    }
    
    return [CloudInfiniteTools base64DecodeString:_text];
}

- (NSString *)fontNameToString{
    NSString * fontName = _font.fontName;
    if (fontName == nil) {
        fontName = @"tahoma.ttf";
    }
    return [CloudInfiniteTools base64DecodeString:fontName];
}

- (NSString *)textColorToString {
    return [CloudInfiniteTools colorToString:_textColor];
}

- (NSInteger)fontsize{
    if (_fontsize == 0) {
        _fontsize = 13;
    }
    return _fontsize;
}

- (NSInteger)degree{
    if (_degree > 360) {
        _degree = _degree % 360;
    }
    
    if (_degree < 0) {
        _degree = 0;
    }
    return _degree;
}

- (NSInteger)dissolve{
    if (_dissolve < 1) {
        _dissolve = 90;
    }
    
    if (_dissolve > 100) {
        _dissolve = 100;
    }
    return _dissolve;
}

-(NSString *)buildPartUrl{
    return [NSString stringWithFormat:@"watermark/2/text/%@/font/%@/fontsize/%ld/fill/%@/dissolve/%ld/gravity/%@/dx/%.0f/dy/%.0f/batch/%u/degree/%ld",[self textBase64],[self fontNameToString],self.fontsize,[self textColorToString],self.dissolve,[CloudInfiniteTools gravityToString:self.gravity],self.dx,self.dy,self.batch,self.degree];
}

@end
