//
//  CIGaussianBlur.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIGaussianBlur.h"

@interface CIGaussianBlur ()
@property(nonatomic,assign)CGFloat sigma;

@property(nonatomic,assign)CGFloat bRadius;
@end

@implementation CIGaussianBlur
-(instancetype)initWithBlurRadius:(CGFloat)bRadius sigma:(CGFloat)sigma{
    
    if (self == [super init]) {
        if (bRadius > 50) {
            bRadius = 50;
        }
        
        if (bRadius <1) {
            bRadius = 1;
        }
        
        if (sigma < 1) {
            sigma = 1;
        }
        self.bRadius = bRadius;
        self.sigma = sigma;
    }
    return self;
}

- (NSString *)buildPartUrl{
    NSString * partUrl;
    if (self.bRadius >0 && self.sigma > 0) {
        partUrl = [NSString stringWithFormat:@"imageMogr2/blur/%.0fx%.0f",self.bRadius,self.sigma];
    }
    return partUrl;
}

@end
