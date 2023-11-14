//
//  CloudInfiniteTools.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CloudInfiniteTools.h"


@implementation CloudInfiniteTools

+(NSString *)imageTypeToString:(CIImageFormat )format{
    NSString * formatString;
    switch (format) {
            
        case CIImageTypeAUTO:
            formatString = @"*";
            break;
        case CIImageTypeTPG:
            formatString = @"tpg";
            break;
        case CIImageTypePNG:
            formatString = @"png";
            break;
        case CIImageTypeJPG:
            formatString = @"jpg";
            break;
        case CIImageTypeBMP:
            formatString = @"bmp";
            break;
        case CIImageTypeGIF:
            formatString = @"gif";
            break;
        case CIImageTypeHEIC:
            formatString = @"heif";
            break;
        case CIImageTypeWEBP:
            formatString = @"webp";
            break;
        case CIImageTypeYJPEG:
            formatString = @"yjpeg";
            break;
        case CIImageTypeAVIF:
            formatString = @"avif";
            break;
        default:
            formatString = @"*";
            break;
    }
    return formatString;
}

+ (NSString *)gravityToString:(CloudInfiniteGravity)gravity{
    
    NSString * gravityString;
    switch (gravity) {
            
        case CIGravityNorthWest:
            gravityString = @"northwest";
            break;
        case CIGravityNorth:
            gravityString = @"north";
            break;
        case CIGravityNorthEast:
            gravityString = @"northeast";
            break;
        case CIGravityWest:
            gravityString = @"west";
            break;
        case CIGravityEast:
            gravityString = @"east";
            break;
        case CIGravityCenter:
            gravityString = @"center";
            break;
        case CIGravitySouthWest:
            gravityString = @"southwest";
            break;
        case CIGravitySouth:
            gravityString = @"south";
            break;
        case CIGravitySouthEast:
            gravityString = @"southeast";
            break;
        default:
            gravityString = @"southeast";
            break ;
    }
    return gravityString;
}

+ (NSString *)colorToString:(UIColor *)color {
    
    if (color == nil) {
        return [CloudInfiniteTools base64DecodeString:@"#3D3D3D"];
    }
    
    CGFloat red, green, blue, alpha;
#if SD_UIKIT
    if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) {
        [color getWhite:&red alpha:&alpha];
        green = red;
        blue = red;
    }
#else
    @try {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    @catch (NSException *exception) {
        [color getWhite:&red alpha:&alpha];
        green = red;
        blue = red;
    }
#endif
    
    red = roundf(red * 255.f);
    green = roundf(green * 255.f);
    blue = roundf(blue * 255.f);
    
    uint hex = (((uint)red << 16) | ((uint)green << 8) | ((uint)blue));
    
    return [CloudInfiniteTools base64DecodeString:[NSString stringWithFormat:@"#%06x", hex]];
}

+ (NSString *)base64DecodeString:(NSString *)string{
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    NSString * base64Str = [data base64EncodedStringWithOptions:0];
    
    base64Str = [base64Str stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64Str = [base64Str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64Str;
}
@end
