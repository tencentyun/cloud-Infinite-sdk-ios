//
//  CIImageAveDecoder.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/6.
//

#import "CIImageAveDecoder.h"

@implementation CIImageAveDecoder
+ (void)load{
    [[SDImageCodersManager sharedManager] addCoder:[CIImageAveDecoder new]];
}

- (BOOL)canDecodeFromData:(nullable NSData *)data{
    if (data == nil || data.length == 0) {
        return NO;
    }
    
    NSDictionary * colorDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
    if (colorDic != nil) {
        return YES;
    }
    return NO;
}

- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data
                                   options:(nullable SDImageCoderOptions *)options{
    
    if(data == nil){
        return nil;
    }
    NSDictionary * colorDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
    if (colorDic == nil) {
        
        return nil;
    }
    NSString * colorStr = colorDic[@"RGB"];
    if (colorStr.length != 8) {
        return nil;
    }
    int red = (int)strtoul([[colorStr substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
    int green = (int)strtoul([[colorStr substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);
    int blue = (int)strtoul([[colorStr substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16);
    UIColor * aveColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    UIImage * image = [self imageWithColor:aveColor];;
    return image;
    
    
}

- (BOOL)canEncodeToFormat:(SDImageFormat)format {
    return NO;
}


- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format options:(nullable SDImageCoderOptions *)options {
    return nil;
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
