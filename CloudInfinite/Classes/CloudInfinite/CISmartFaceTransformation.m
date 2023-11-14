//
//  SmartFaceTransformation.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CISmartFaceTransformation.h"
#import "CloudInfiniteEnum.h"

@implementation CISmartFaceTransformation
- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithView:view scaleType:ScaleTypeAUTOFit];
    if (self) {
        [self setCutWithScrop:view.frame.size.width height:view.frame.size.height];
    }
    return self;
}
@end
