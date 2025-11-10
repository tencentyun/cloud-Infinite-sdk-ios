//
//  CIAdjustViewController.h
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import <UIKit/UIKit.h>
#import "CIEditedAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIAdjustViewController : UIViewController

@property (nonatomic, strong) CIEditedAsset *editedAsset;

// UI Components
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISlider *exposureSlider;
@property (nonatomic, strong) UISlider *contrastSlider;
@property (nonatomic, strong) UISlider *saturationSlider;
@property (nonatomic, strong) UISlider *sepiaSlider;

- (instancetype)initWithEditedAsset:(CIEditedAsset *)editedAsset;

@end

NS_ASSUME_NONNULL_END
