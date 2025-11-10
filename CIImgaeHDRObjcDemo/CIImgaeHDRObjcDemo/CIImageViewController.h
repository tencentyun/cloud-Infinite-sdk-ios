//
//  CIImageViewController.h
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import <UIKit/UIKit.h>
#import "CIAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIImageViewController : UIViewController

@property (nonatomic, strong, nullable) CIAsset *asset;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithAsset:(nullable CIAsset *)asset;

@end

NS_ASSUME_NONNULL_END
