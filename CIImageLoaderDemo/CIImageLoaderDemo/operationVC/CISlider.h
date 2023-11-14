//
//  CISlider.h
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/13.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CISlider : UIView
@property(nonatomic,assign)BOOL enabled;

@property (nonatomic,strong)NSString * titleString;

@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end

NS_ASSUME_NONNULL_END
