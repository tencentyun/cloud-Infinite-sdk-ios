//
//  CIEditedAsset.h
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <CoreImage/CoreImage.h>
#import "CIAsset.h"
#import "CIAdjustment.h"
#import "CIRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@class CIEditedAsset;

@protocol CIEditedAssetDelegate <NSObject>
- (void)editedAsset:(CIEditedAsset *)editedAsset didUpdateAdjustment:(CIAdjustment *)adjustment;
- (void)editedAsset:(CIEditedAsset *)editedAsset didFinishWithAsset:(nullable CIAsset *)asset;
@end

@interface CIEditedAsset : NSObject

@property (nonatomic, strong, readonly) CIAsset *asset;
@property (nonatomic, strong, readonly) CIAdjustment *adjustment;
@property (nonatomic, strong, readonly) CIRenderer *renderer;
@property (nonatomic, strong, readonly, nullable) PHContentEditingInput *editingInput;
@property (nonatomic, strong, readonly, nullable) PHContentEditingOutput *editingOutput;
@property (nonatomic, weak) id<CIEditedAssetDelegate> delegate;

// Computed properties
@property (nonatomic, strong, readonly) NSString *defaultFilename;
@property (nonatomic, strong, readonly, nullable) CIImage *renderedImage;

// Initializers
- (instancetype)initWithAsset:(CIAsset *)asset renderer:(CIRenderer *)renderer;

// Adjustment methods
- (void)updateAdjustment:(CIAdjustment *)adjustment;
- (void)resetAdjustments;

// Export methods
- (void)exportToURL:(NSURL *)url completion:(void (^)(BOOL success, NSError * _Nullable error))completion;
- (nullable NSData *)exportToJPEGData;

// Photo library methods (for PHAsset editing)
- (void)prepareForPhotoLibraryEdit:(void (^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
