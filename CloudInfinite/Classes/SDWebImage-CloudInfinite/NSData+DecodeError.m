//
//  NSData+DecodeError.m
//  CloudInfinite
//
//  Created by garenwang on 2023/5/19.
//

#import "NSData+DecodeError.h"
#import <objc/runtime.h>
@implementation NSData (DecodeError)
- (NSError *)decodeError{
    return objc_getAssociatedObject(self, @"decodeError");
}

- (void)setDecodeError:(NSError *)decodeError{
    objc_setAssociatedObject(self, @"decodeError", decodeError, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
