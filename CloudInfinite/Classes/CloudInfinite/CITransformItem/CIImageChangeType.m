//
//  CIImageChangeType.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIImageChangeType.h"
#import "CloudInfiniteTools.h"

@interface CIImageChangeType ()

@property(nonatomic,assign)CIImageFormat format;

@property(nonatomic,assign)CILoadTypeEnum options;

@property(nonatomic,assign)NSInteger cgif;

@property(nonatomic,assign)BOOL interlace;

@end

@implementation CIImageChangeType

-(instancetype)initWithFormat:(CIImageFormat)format options:(CILoadTypeEnum)options{
    if (self = [super init]) {
        self.format = format;
        self.options = options;
    }
    return self;
}

-(instancetype)initWithCgif:(NSInteger)cgif{
    if (self = [super init]) {
        if (cgif < 1) {
            cgif = 1;
        }
        
        if (cgif > 100) {
            cgif = 100;
        }
        
        self.cgif = cgif;
    }
    return self;
}

-(instancetype)initWithInterlace:(BOOL)interlace{
    if (self = [super init]) {
        self.interlace = interlace;
    }
    return self;
}

-(BOOL)isOnlyHeader{
    if (self.format != 0 && self.options == CILoadTypeAcceptHeader) {
        return YES;
    }
    return NO;
}

-(NSString *)buildPartUrlWithHeader{
    return [NSString stringWithFormat:@"imageMogr2/format/%@",[CloudInfiniteTools imageTypeToString:self.format]];
}

- (NSString *)buildPartUrl{
    NSString * partUrl;
    if (self.format != 0) {
        if (self.options == CILoadTypeAcceptHeader) {
            return [CloudInfiniteTools imageTypeToString:self.format];
        }else{
            partUrl = [NSString stringWithFormat:@"imageMogr2/format/%@",[CloudInfiniteTools imageTypeToString:self.format]];
        }
    }else if (self.cgif > 0){
        partUrl = [NSString stringWithFormat:@"imageMogr2/cgif/%ld",self.cgif];
    }else if (self.interlace == YES){
        partUrl = [NSString stringWithFormat:@"imageMogr2/interlace/%u",self.interlace];
    }
    return partUrl;
}
@end
