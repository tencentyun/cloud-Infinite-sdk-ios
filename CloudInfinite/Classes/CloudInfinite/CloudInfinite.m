//
//  CloudInfinite.m
//  CloudInfinite
//
//  Created by garenwang on 2020/7/23.
//

#import "CloudInfinite.h"
#import "CIMemoryCache.h"
#import "CITransformItem/CIImageChangeType.h"

@implementation CloudInfinite
-(void)requestWithBaseUrl:(NSString *)url transform:(CITransformation *)transformation request:(void (^) (CIImageLoadRequest * request)) request{
    CIImageLoadRequest * loadRequest = [self requestWithBaseUrl:url transform:transformation];
    request(loadRequest);
}

-(CIImageLoadRequest *)requestWithBaseUrl:(NSString *)url transform:(CITransformation *)transformation{
    CIImageLoadRequest * loadRequest = [[CIImageLoadRequest alloc]initWithBaseURL:url];
    
    if (transformation.transformArrays .count == 1 && [[transformation.transformArrays firstObject] isKindOfClass:[CIImageChangeType class]]) {
        CIImageChangeType * changeType = (CIImageChangeType *)[transformation.transformArrays firstObject];
        if ([changeType isOnlyHeader]) {
            loadRequest.header = [changeType buildPartUrl];
        }else{
            [loadRequest addURLPart:[changeType buildPartUrl]];
        }
    }else{
        NSMutableArray * parts = [NSMutableArray new];
        for (int i = 0; i < transformation.transformArrays.count; i ++) {
            
            id<CITransformActionProtocol > action = transformation.transformArrays[i];
            // 当有多组操作并且其中格式转换为header的方式，将header转换为url形式
            if ([action isKindOfClass:[CIImageChangeType class]]) {
                CIImageChangeType * actionChange = (CIImageChangeType *)action;
                if ([actionChange isOnlyHeader]) {
                    [parts addObject:[actionChange buildPartUrlWithHeader]];
                    continue;
                }
            }
            
            if ([action buildPartUrl] != nil && [action buildPartUrl].length > 0) {
                [parts addObject: [action buildPartUrl]];
            }
        }
        [loadRequest addURLPart:[parts componentsJoinedByString:@"|"]];
    }
    
    if(transformation.ignoreError){
        if([loadRequest.url.absoluteString containsString:@"imageMogr2"]){
            [loadRequest appendURLPart:@"/ignore-error/1"];
        }else{
            [loadRequest appendURLPart:@"imageMogr2/ignore-error/1"];
        }
        
        
    }
    return loadRequest;
}

@end

