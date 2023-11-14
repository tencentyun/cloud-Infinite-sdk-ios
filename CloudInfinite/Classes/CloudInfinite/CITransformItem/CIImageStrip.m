//
//  CIImageStrip.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIImageStrip.h"

@interface CIImageStrip ()
@property (nonatomic,assign)BOOL isStrip;
@end

@implementation CIImageStrip
-(instancetype)initStrip{
    if(self == [super init]){
        _isStrip = YES;
    }
    return self;
}

- (NSString *)buildPartUrl{
    if (!_isStrip) {
        return nil;
    }
    return @"imageMogr2/strip";
}
@end
