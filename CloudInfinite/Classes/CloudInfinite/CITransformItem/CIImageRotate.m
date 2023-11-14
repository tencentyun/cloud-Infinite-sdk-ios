//
//  CIImageRotate.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIImageRotate.h"

@interface CIImageRotate ()

@property(nonatomic,assign)NSInteger degree;

@property(nonatomic,assign)BOOL autoOrient;

@end

@implementation CIImageRotate
-(instancetype)initWithRotate:(NSInteger)degree{
    if (self  == [super init]) {
        if (degree > 360) {
            degree = degree % 360;
        }
        if (degree < 0) {
            degree = 0;
        }
        self.degree = degree;
    }
    return self ;
}


- (instancetype)initWithAutoOrientWith:(BOOL)autoOrient{
    if (self  == [super init]) {
        self.autoOrient = autoOrient;
    }
    return self;
}

- (NSString *)buildPartUrl{
    NSString * partUrl;
    if (self.degree > 0) {
        partUrl = [NSString stringWithFormat:@"imageMogr2/rotate/%ldf",self.degree];
        
    }
    if (self.autoOrient) {
        partUrl = [NSString stringWithFormat:@"imageMogr2/auto-orient"];
    }
    return partUrl;
}
@end
