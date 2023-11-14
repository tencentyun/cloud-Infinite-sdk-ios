//
//  CIResponsiveTransformation.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIResponsiveTransformation.h"
#import "CloudInfiniteEnum.h"
@implementation CIResponsiveTransformation
- (instancetype)initWithView:(UIView *)view scaleType:(ScaleType)scaleType
{
    self = [super init];
    if (self) {
        CGFloat version = [[UIDevice currentDevice].systemVersion doubleValue];
        if (version >= 11.0) {
            [self setFormatWith:CIImageTypeHEIC options:CILoadTypeUrlFooter];
        }
        [self setZoomWithWidth:view.frame.size.width height:view.frame.size.height scaleType:scaleType];
    }
    return self;
}
@end
