//
//  QCloudHTTPRequestOperation+CI.m
//  CloudInfinite
//
//  Created by garenwang on 2023/5/10.
//

#import "QCloudHTTPRequestOperation+CI.h"

@implementation QCloudHTTPRequestOperation (CI)

- (void)cancel{
    [self.request cancel];
}
@end
