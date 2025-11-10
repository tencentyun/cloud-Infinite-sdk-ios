//
//  CIImageViewController.m
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import "CIImageViewController.h"

@interface CIImageViewController ()

@end

@implementation CIImageViewController

- (instancetype)initWithAsset:(nullable CIAsset *)asset {
    self = [super init];
    if (self) {
        _asset = asset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupImageView];
    [self loadImage];
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.preferredImageDynamicRange = UIImageDynamicRangeHigh;
    
    [self.view addSubview:self.imageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (void)loadImage {
    if (!self.asset) {
        self.imageView.image = nil;
        return;
    }
    
    // Try to use thumbnail first for better performance
    if (self.asset.thumbnail) {
        self.imageView.image = [UIImage imageWithCGImage:self.asset.thumbnail];
    } else {
        // Load full image if no thumbnail available
        CGImageRef fullImage = [self.asset loadFullImage];
        if (fullImage) {
            self.imageView.image = [UIImage imageWithCGImage:fullImage];
            CGImageRelease(fullImage);
        }
    }
}

- (void)setAsset:(CIAsset *)asset {
    _asset = asset;
    if (self.isViewLoaded) {
        [self loadImage];
    }
}

@end
