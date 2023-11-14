//
//  CIQualityChange.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIQualityChange.h"



@interface CIQualityChange ()

@property (nonatomic,assign)CIQualityChangeEnum qualityType;

@property(nonatomic,assign)NSInteger quality;

@end

@implementation CIQualityChange
- (instancetype)initWithQuality:(NSInteger)quality type:(CIQualityChangeEnum)type
{
    self = [super init];
    if (self) {
        _qualityType = type;
        _quality = quality;
    }
    return self;
}

-(NSString *)buildPartUrl{
    NSString * partUrl;
    if (_qualityType == CIQualityChangeAbsolute) {
        partUrl = [NSString stringWithFormat:@"imageMogr2/quality/%ld",self.quality];
    }else if (_qualityType == CIQualityChangeAbsoluteFix){
        partUrl = [NSString stringWithFormat:@"imageMogr2/quality/%ld!",self.quality];
    }else if (_qualityType == CIQualityChangeRelative){
        partUrl = [NSString stringWithFormat:@"imageMogr2/rquality/%ld",self.quality];
    }else{
        partUrl = [NSString stringWithFormat:@"imageMogr2/lquality/%ld",self.quality];
    }
    return partUrl;
}

@end
