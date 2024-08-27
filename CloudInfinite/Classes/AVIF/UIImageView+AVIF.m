//
//  UIImageView+AVIF.m
//  CloudInfinite
//
//  Created by garenwang on 2021/11/17.
//

#import "UIImageView+AVIF.h"
#import "AVIFDecoderHelper.h"

@implementation UIImageView (AVIF)
-(void)setAvifImageWithPath:(NSURL *)fileUrl
              loadComplete:(nullable AVIFImageViewLoadComplete)complete{
    self.image = [UIImage new];
    __block NSData * imageData ;
    dispatch_semaphore_t smp = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        imageData = [NSData dataWithContentsOfFile:fileUrl.absoluteString];
        dispatch_semaphore_signal(smp);
    });
    dispatch_semaphore_wait(smp, DISPATCH_TIME_FOREVER);
    [self setAvifImageWithData:imageData loadComplete:complete];
}

-(void)setAvifImageWithData:(NSData *)imageData
              loadComplete:(nullable AVIFImageViewLoadComplete)complete{
    
    self.image = [UIImage new];
    
    __block UIImage * image;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError * error;
        image = [AVIFDecoderHelper imageDataDecode:imageData error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
            if (complete) {
                complete(imageData,image,error);
            }
        });
    });
}

@end
