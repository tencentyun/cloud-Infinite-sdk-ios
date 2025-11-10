//
//  CIAdjustment.h
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIAdjustment : NSObject

@property (nonatomic, assign) double exposure;
@property (nonatomic, assign) double contrast;
@property (nonatomic, assign) double saturation;
@property (nonatomic, assign) double sepia;

// Initializers
- (instancetype)init;
- (instancetype)initWithExposure:(double)exposure 
                        contrast:(double)contrast 
                      saturation:(double)saturation 
                           sepia:(double)sepia;

// Copy constructor
- (instancetype)initWithAdjustment:(CIAdjustment *)adjustment;

// Utility methods
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;
- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
