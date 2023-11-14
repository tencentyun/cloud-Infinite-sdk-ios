//
//  UIImage+AVIFDecode.h
//  CloudInfinite
//
//  Created by garenwang on 2020/7/15.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (AVIFDecode)

+(UIImage*)AVIFImageWithContentsOfData:(NSData*)data error:(NSError * __autoreleasing*)error;

+(UIImage*)AVIFImageWithContentsOfData:(NSData *)data scale:(int)scale rect:(CGRect)rect error:(NSError * __autoreleasing*)error;

+(UIImage*)AVIFImageWithContentsOfData:(NSData*)data;

+(UIImage*)AVIFImageWithContentsOfData:(NSData *)data scale:(int)scale rect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
