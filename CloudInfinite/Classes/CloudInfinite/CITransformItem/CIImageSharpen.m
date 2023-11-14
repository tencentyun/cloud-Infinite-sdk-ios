//
//  CIImageSharpen.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIImageSharpen.h"

@interface CIImageSharpen ()
@property(nonatomic,assign)CGFloat sharpen;
@end

@implementation CIImageSharpen
- (instancetype)initWithSharpe:(CGFloat)sharpen
{
    self = [super init];
    if (self) {
        _sharpen = sharpen;
    }
    return self;
}

- (NSString *)buildPartUrl{
    
    NSString * partUrl;
    if (self.sharpen >= 10) {
        partUrl = [NSString stringWithFormat:@"imageMogr2/sharpen/%.0f",self.sharpen];
    }
    return partUrl;
}
@end
