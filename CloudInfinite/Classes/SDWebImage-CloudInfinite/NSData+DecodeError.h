//
//  NSData+DecodeError.h
//  CloudInfinite
//
//  Created by garenwang on 2023/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (DecodeError)
@property (nonatomic,strong) NSError * decodeError;
@end

NS_ASSUME_NONNULL_END
