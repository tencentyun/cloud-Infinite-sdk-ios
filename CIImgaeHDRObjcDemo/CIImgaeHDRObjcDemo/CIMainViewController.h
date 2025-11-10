//
//  CIMainViewController.h
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import "CIAsset.h"
#import "CIEditedAsset.h"
#import "CIRenderer.h"
#import "CIFilmStripView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIMainViewController : UIViewController <PHPickerViewControllerDelegate, UIDocumentPickerDelegate, CIEditedAssetDelegate, CIFilmStripViewDelegate>

@property (nonatomic, strong) CIRenderer *renderer;
@property (nonatomic, strong) NSMutableArray<CIAsset *> *assets;
@property (nonatomic, strong, nullable) CIAsset *selectedAsset;
@property (nonatomic, strong, nullable) CIAsset *defaultAsset;
@property (nonatomic, strong, nullable) CIEditedAsset *editedAsset;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isImporting;
@property (nonatomic, assign) BOOL isExporting;

// UI Components
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CIFilmStripView *filmStripView;
@property (nonatomic, strong) UIButton *importButton;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;

@end

NS_ASSUME_NONNULL_END
