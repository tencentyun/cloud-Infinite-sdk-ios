//
//  CIImageTailor.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIImageTailor.h"
#import "CloudInfiniteTools.h"

@interface CIImageTailor ()

@property(nonatomic,assign)CGFloat rRadius;


@property(nonatomic,assign)CGFloat iRadius;


@property(nonatomic,assign)CGSize scropSize;


@property(nonatomic,assign)CGSize cropSize;


@property(nonatomic,assign)CGRect cutRect;

@property(nonatomic,assign)CloudInfiniteGravity gravity;
@end

@implementation CIImageTailor


-(instancetype)initWithCut:(CGFloat)width height:(CGFloat)height dx:(CGFloat)x dy:(CGFloat)y{
    if (self  == [super init]) {
        self.cutRect = CGRectMake(x, y, width, height);
    }
    return self;
}

-(instancetype)initWithIRadius:(CGFloat)radius{
    if (self  == [super init]) {
        self.iRadius = radius;
    }
    return self;
}

-(instancetype)initWithRRadius:(CGFloat)radius{
    if (self  == [super init]) {
        self.rRadius = radius;
    }
    return self;
}

-(instancetype)initWithScrop:(CGFloat)width height:(CGFloat)height{
    if (self  == [super init]) {
        self.scropSize = CGSizeMake(width, height);
    }
    return self;
}

-(instancetype)initWithCrop:(CGFloat)width height:(CGFloat)height gravity:(CloudInfiniteGravity) gravity{
    if (self  == [super init]) {
        self.cropSize = CGSizeMake(width, height);
        self.gravity = gravity;
    }
    return self;
}

- (NSString *)buildPartUrl{
    NSString * partUrl;
    if (self.rRadius > 0) {
        partUrl = [NSString stringWithFormat:@"imageMogr2/rradius/%.0f",self.rRadius];
    }
    
    if (self.iRadius > 0) {
        partUrl = [NSString stringWithFormat:@"imageMogr2/iradius/%.0f",self.iRadius];
    }
    
    if (!CGRectEqualToRect(self.cutRect, CGRectZero)) {
        
        partUrl = [NSString stringWithFormat:@"imageMogr2/cut/%.0fx%.0fx%.0fx%.0f",self.cutRect.size.width,
                              self.cutRect.size.height,
                              self.cutRect.origin.x,
                              self.cutRect.origin.y];
    }
    
    if (!CGSizeEqualToSize(self.cropSize, CGSizeZero)) {
        NSString * gravity = @"";
        if (_gravity != CIGravityNone) {
            gravity = [NSString stringWithFormat:@"/gravity/%@",[CloudInfiniteTools gravityToString:_gravity]];
        }
        
        if (self.cropSize.width == 0) {
            partUrl = [NSString stringWithFormat:@"imageMogr2/crop/x%.0f%@",self.cropSize.height,gravity];
        }else if (self.cropSize.height == 0){
            partUrl = [NSString stringWithFormat:@"imageMogr2/crop/%.0fx%@",self.cropSize.width,gravity];
        }else{
            partUrl = [NSString stringWithFormat:@"imageMogr2/crop/%.0fx%.0f%@",self.cropSize.width,self.cropSize.height,gravity];
        }
    }
    
    if (!CGSizeEqualToSize(self.scropSize, CGSizeZero)) {
        
        if (self.scropSize.width == 0) {
            partUrl = [NSString stringWithFormat:@"imageMogr2/scrop/x%.0f",self.scropSize.height];
        }else if (self.scropSize.height == 0){
            partUrl = [NSString stringWithFormat:@"imageMogr2/scrop/%.0fx",self.scropSize.width];
        }else{
            partUrl = [NSString stringWithFormat:@"imageMogr2/scrop/%.0fx%.0f",self.scropSize.width,self.scropSize.height];
        }
    }
    return partUrl;
}
@end
