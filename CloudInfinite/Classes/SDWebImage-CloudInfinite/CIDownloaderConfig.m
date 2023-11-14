//
//  CIDownloaderConfig.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/4.
//

#import "CIDownloaderConfig.h"
#import <objc/runtime.h>
#import "UIView+CI.h"

@interface CIDownloaderConfig ()

@property(nonatomic,strong)NSMutableDictionary * tpgRegularExpressions;

@property(nonatomic,strong)NSMutableArray * excloudeRegularExpressions;


@end

@implementation CIDownloaderConfig

+ (instancetype) sharedConfig {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[CIDownloaderConfig alloc]init];
    });
    
    return instance;
}

- (NSMutableArray *)excloudeRegularExpressions{
    if (_excloudeRegularExpressions == nil) {
        _excloudeRegularExpressions = [NSMutableArray new];
    }
    return _excloudeRegularExpressions;
}

- (NSMutableDictionary *)tpgRegularExpressions{
    if (_tpgRegularExpressions == nil) {
        _tpgRegularExpressions = [NSMutableDictionary new];
    }
    return _tpgRegularExpressions;
}

/// 添加一个正则表达式来校验是否请求TPG
/// @param regularStr 正则
-(void)addTPGRegularExpress:(NSString *)regularStr paramsType:(CILoadTypeEnum)type{
    
    if (regularStr == nil) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method system = class_getInstanceMethod([UIView class], @selector(sd_TPG_internalSetImageWithURL:placeholderImage:options:context:setImageBlock:progress:completed:));
        //获取自己方法结构体
        Method own = class_getInstanceMethod([UIView class], @selector(sd_internalSetImageWithURL:placeholderImage:options:context:setImageBlock:progress:completed:));
        method_exchangeImplementations(system, own);
    });
    
    [self.tpgRegularExpressions setObject:@(type) forKey:regularStr];
    
}


-(void)addExcloudeTPGRegularExpress:(NSString *)regularStr{
    [self.excloudeRegularExpressions addObject:regularStr];
}

@end
