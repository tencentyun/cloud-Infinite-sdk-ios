//
//  CIAdjustment.m
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import "CIAdjustment.h"

@implementation CIAdjustment

- (instancetype)init {
    return [self initWithExposure:0.0 contrast:1.0 saturation:1.0 sepia:0.0];
}

- (instancetype)initWithExposure:(double)exposure 
                        contrast:(double)contrast 
                      saturation:(double)saturation 
                           sepia:(double)sepia {
    self = [super init];
    if (self) {
        _exposure = exposure;
        _contrast = contrast;
        _saturation = saturation;
        _sepia = sepia;
    }
    return self;
}

- (instancetype)initWithAdjustment:(CIAdjustment *)adjustment {
    return [self initWithExposure:adjustment.exposure 
                         contrast:adjustment.contrast 
                       saturation:adjustment.saturation 
                            sepia:adjustment.sepia];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CIAdjustment class]]) {
        return NO;
    }
    
    CIAdjustment *other = (CIAdjustment *)object;
    return (fabs(self.exposure - other.exposure) < 0.001 &&
            fabs(self.contrast - other.contrast) < 0.001 &&
            fabs(self.saturation - other.saturation) < 0.001 &&
            fabs(self.sepia - other.sepia) < 0.001);
}

- (NSUInteger)hash {
    return (NSUInteger)(self.exposure * 1000) ^ 
           (NSUInteger)(self.contrast * 1000) ^ 
           (NSUInteger)(self.saturation * 1000) ^ 
           (NSUInteger)(self.sepia * 1000);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"CIAdjustment(exposure: %.3f, contrast: %.3f, saturation: %.3f, sepia: %.3f)", 
            self.exposure, self.contrast, self.saturation, self.sepia];
}

@end
