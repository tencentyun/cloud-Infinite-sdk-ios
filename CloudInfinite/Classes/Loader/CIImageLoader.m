//
//  CITPGImageLoader.m
//  CloudInfinite
//
//  Created by garenwang on 2020/7/20.
//

#import "CIImageLoader.h"
#import <QCloudCore/QCloudCore.h>
#import "CIImageRequest.h"
#import "CIMemoryCache.h"

@implementation CIImageLoader

+ (CIImageLoader*) shareLoader{
    static CIImageLoader* loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[CIImageLoader alloc]init];
    });
    return loader;
}

-(void)loadData:(CIImageLoadRequest*)loadRequest
   loadComplete:(nullable LoadImageComplete)complete;{
    
    if (loadRequest.url == nil) {
        NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:10000 userInfo:@{NSLocalizedDescriptionKey:@"CIImageLoader：loadData 图片URL参数异常"}];
        complete(nil,error);
        return;
    }
    
    // 用 CIImageLoadRequest 示例中构建号的url和header 初始化一个 CIImageRequest；
    CIImageRequest * request = [[CIImageRequest alloc]initWithImageUrl:loadRequest.url andHeader:loadRequest.header];
    
    // 执行CIImageRequest 示例开始请求图片
    [[QCloudHTTPSessionManager shareClient] performRequest:request withFinishBlock:^(id outputObject, NSError *error) {
        NSLog(@"%@",request);
        if (error || ![outputObject isKindOfClass:[NSDictionary class]]) {
            if (complete) {
                complete(nil,error);
            }
            return;
        }
        if (outputObject[@"data"] == nil) {
            if (complete) {
                complete(nil,error);
            }
            return;
        }
        NSData * imageData = outputObject[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(imageData,error);
            }
        });
    }];
}

-(void)display:(UIImageView *)imageView
   loadRequest:(CIImageLoadRequest*)loadRequest
   placeHolder:(UIImage *)placeHolder
  loadComplete:(nullable LoadImageComplete)complete;{
    
    if (placeHolder) {
        imageView.image = placeHolder;
    }
    
    if (loadRequest.url == nil) {
        NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:10000 userInfo:@{NSLocalizedDescriptionKey:@"CIImageLoader：display 图片URL参数异常"}];
        if (complete) {
            complete(nil,error);
        }
        return;
    }
    
    // 用 CIImageLoadRequest 示例中构建号的url和header 初始化一个 CIImageRequest；
    CIImageRequest * request = [[CIImageRequest alloc]initWithImageUrl:loadRequest.url andHeader:loadRequest.header];
    
    // 执行CIImageRequest 示例开始请求图片
    [[QCloudHTTPSessionManager shareClient] performRequest:request withFinishBlock:^(id outputObject, NSError *error) {
        NSLog(@"%@",request);
        if (error || ![outputObject isKindOfClass:[NSDictionary class]]) {
            if (complete) {
                complete(nil,error);
            }
            return;
        }
        if (outputObject[@"data"] == nil) {
            if (complete) {
                complete(nil,error);
            }
            return;
        }
        NSData * imageData = outputObject[@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage * image = [UIImage imageWithData:imageData];
            if (image == nil) {
                NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:40000 userInfo:@{NSLocalizedDescriptionKey:@"图片data数据转image错误"}];
                if (complete) {
                    complete(imageData,error);
                }
                return;
            }
            // 显示请求的image，并返回imagedata以及错误信息
            imageView.image = image;
            if (complete) {
                complete(imageData,error);
            }
        });
    }];
}

-(void)preloadWithAveColor:(UIView *)view objectUrl:(NSString *)objectUrl complete:(nullable void(^)(UIColor * color)) aveColorBlock{
    
    if (objectUrl == nil) {
        aveColorBlock(nil);
        return;
    }
    if ([objectUrl containsString:@"?"]) {
        objectUrl = [[objectUrl componentsSeparatedByString:@"?"] firstObject];
    }
    
    objectUrl = [objectUrl stringByAppendingString:@"?imageAve"];
    __block UIColor * aveColor;
    aveColor = (UIColor *)[[CIMemoryCache sharedMemoryCache] objectForKey:objectUrl];
    view.backgroundColor = aveColor;
    if (aveColorBlock && aveColor) {
        aveColorBlock(aveColor);
        return;
    }
    
    CIImageRequest * request = [[CIImageRequest alloc]initWithImageUrl:[NSURL URLWithString:objectUrl] andHeader:nil];
    
    // 执行CIImageRequest 示例开始请求图片
    [[QCloudHTTPSessionManager shareClient] performRequest:request withFinishBlock:^(id outputObject, NSError *error) {
        
        NSDictionary * colorDic = [NSJSONSerialization JSONObjectWithData:outputObject[@"data"] options:NSJSONReadingFragmentsAllowed error:nil];
        if (error) {
            NSLog(@"getImageAveColor_error:%@",error.userInfo);
            if (aveColorBlock) {
                aveColorBlock(nil);
            }
            return;
        }
        NSString * colorStr = colorDic[@"RGB"];
        if (colorStr.length == 8) {
            int red = (int)strtoul([[colorStr substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
            int green = (int)strtoul([[colorStr substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);
            int blue = (int)strtoul([[colorStr substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16);
            aveColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
        }
        [[CIMemoryCache sharedMemoryCache] setObject:aveColor forKey:objectUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            view.backgroundColor = aveColor;
        });
        if (aveColorBlock) {
            aveColorBlock(aveColor);
        }
    }];
}
@end
