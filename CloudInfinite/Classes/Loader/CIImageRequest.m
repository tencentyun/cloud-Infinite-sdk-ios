//
//  CITPGImageRequest.m
//  CloudInfinite
//
//  Created by garenwang on 2020/7/14.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CIImageRequest.h"

@interface CIImageRequest ()
@property (nonatomic,strong)NSURL * imageUrl;
@property (nonatomic,strong)NSDictionary *customHeader;
@end

@implementation CIImageRequest

QCloudResponseSerializerBlock QCloudResponseDataAppendHeadersSerializerBlock1 = ^(NSHTTPURLResponse* response,  id inputData, NSError* __autoreleasing* error)
{
    NSMutableDictionary* allDatas = [NSMutableDictionary new];
    if ([inputData isKindOfClass:[NSDictionary class]]) {
        [allDatas addEntriesFromDictionary:(NSDictionary*)inputData];
    }else{
        if(inputData != nil){
            [allDatas setObject:inputData forKey:@"data"];
        }
    }
    [allDatas addEntriesFromDictionary:response.allHeaderFields];
    
    return (id)allDatas;
};

-(instancetype)initWithImageUrl:(NSURL *)url andHeader:(NSString *)customHeader{
    if (self = [super init]) {
        self.imageUrl = url;
        if (customHeader) {
            self.customHeader = @{@"accept":[NSString stringWithFormat:@"image/%@",customHeader]};
        }
    }
    return self;
}

- (BOOL) buildRequestData:(NSError *__autoreleasing *)error
{
    if (![super buildRequestData:error]) {
        return NO;
    }
    return YES;
}

- (NSURLRequest *)buildURLRequest:(NSError * _Nullable __autoreleasing *)error{
    
    if (![self buildRequestData:error]) {
        return nil;
    }
    
    if (self.imageUrl == nil) {
        *error = [NSError errorWithDomain:NSURLErrorDomain code:10000 userInfo:@{NSLocalizedDescriptionKey:@"CIImageRequest:buildURLRequest imageUrl 不能为空"}];
        return nil;
    }
    
    NSMutableURLRequest*  mRequest = [NSMutableURLRequest requestWithURL:self.imageUrl];
    
    for (NSString * key in self.customHeader.allKeys) {
        [mRequest setValue:[self.customHeader objectForKey:key] forHTTPHeaderField:key];
    }
    
    return  mRequest;
}

- (void)setConfigureBlock:(void (^)(QCloudRequestSerializer * _Nonnull, QCloudResponseSerializer * _Nonnull))configBlock{
    self.responseSerializer.serializerBlocks = @[QCloudResponseDataAppendHeadersSerializerBlock1];
}
@end
