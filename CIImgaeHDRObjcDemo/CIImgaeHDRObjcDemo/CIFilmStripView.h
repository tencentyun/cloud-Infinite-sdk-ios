//
//  CIFilmStripView.h
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import <UIKit/UIKit.h>
#import "CIAsset.h"

NS_ASSUME_NONNULL_BEGIN

@class CIFilmStripView;

@protocol CIFilmStripViewDelegate <NSObject>
- (void)filmStripView:(CIFilmStripView *)filmStripView didSelectAsset:(CIAsset *)asset;
@end

@interface CIFilmStripView : UIView

@property (nonatomic, weak, nullable) id<CIFilmStripViewDelegate> delegate;
@property (nonatomic, strong) NSArray<CIAsset *> *assets;
@property (nonatomic, strong, nullable) CIAsset *selectedAsset;

// UI Components
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)updateAssets:(NSArray<CIAsset *> *)assets selectedAsset:(nullable CIAsset *)selectedAsset;

@end

NS_ASSUME_NONNULL_END
