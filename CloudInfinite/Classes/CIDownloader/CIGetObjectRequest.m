//
//  CIGetObjectRequest.m
//  CloudInfinite
//
//  Created by garenwang on 2023/5/10.
//

#import "CIGetObjectRequest.h"

@interface CIGetObjectRequest ()
@property (strong, nonatomic) NSURL *url;
@end

@implementation CIGetObjectRequest
- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.url = url;
    self.priority = QCloudAbstractRequestPriorityNormal;
    return self;
}
- (void)configureReuqestSerializer:(QCloudRequestSerializer *)requestSerializer responseSerializer:(QCloudResponseSerializer *)responseSerializer {
    NSArray *responseSerializers = @[
        QCloudAcceptRespnseCodeBlock([NSSet setWithObjects:@(200), @(201), @(202), @(203), @(204), @(205), @(206), @(207), @(208), @(226), nil], nil)
    ];
    [responseSerializer setSerializerBlocks:responseSerializers];
    requestSerializer.HTTPMethod = @"get";
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }
    
    if(self.url == nil){
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[url] is invalid (nil), it must have some value. please check it"]];
        }
        return NO;
    }
    
    NSURL *__serverURL = self.url;
    self.requestData.serverURL = __serverURL.absoluteString;
    [self.requestData setValue:__serverURL.host forHTTPHeaderField:@"Host"];
    return YES;
}
@end
