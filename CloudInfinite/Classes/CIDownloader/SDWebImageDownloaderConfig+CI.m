//
//  SDWebImageDownloaderConfig+CI.m
//  CloudInfinite
//
//  Created by garenwang on 2023/3/21.
//

#import "SDWebImageDownloaderConfig+CI.h"
#import <objc/runtime.h>
@implementation SDWebImageDownloaderConfig (CI)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method fromMethod = class_getInstanceMethod(self, @selector(init));
        Method toMethod = class_getInstanceMethod(self, @selector(initCI));
        method_exchangeImplementations(toMethod, fromMethod);
    });
}

-(instancetype)initCI{
    if(self = [self initCI]){
    }
    return self;
}

- (BOOL)enableQuic{
    return [objc_getAssociatedObject(self, @"enableQuic") boolValue];
}

- (void)setEnableQuic:(BOOL)enableQuic{
    objc_setAssociatedObject(self, @"enableQuic", @(enableQuic), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
