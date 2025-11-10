//
//  CIFilmStripView.m
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import "CIFilmStripView.h"

static NSString * const CIFilmStripCellIdentifier = @"CIFilmStripCell";

@interface CIFilmStripCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *selectionOverlay;
@end

@implementation CIFilmStripCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // Image view
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 8;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.preferredImageDynamicRange = UIImageDynamicRangeHigh;
    [self.contentView addSubview:self.imageView];
    
    // Selection overlay
    self.selectionOverlay = [[UIView alloc] init];
    self.selectionOverlay.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.3];
    self.selectionOverlay.layer.cornerRadius = 8;
    self.selectionOverlay.layer.borderWidth = 2;
    self.selectionOverlay.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.selectionOverlay.hidden = YES;
    self.selectionOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.selectionOverlay];
    
    // Constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        
        [self.selectionOverlay.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.selectionOverlay.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.selectionOverlay.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.selectionOverlay.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
}

- (void)configureWithAsset:(CIAsset *)asset isSelected:(BOOL)isSelected {
    // Set image
    if (asset.thumbnail) {
        self.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    } else {
        // Load full image if no thumbnail (this should be done asynchronously in a real app)
        CGImageRef fullImage = [asset loadFullImage];
        if (fullImage) {
            self.imageView.image = [UIImage imageWithCGImage:fullImage];
            CGImageRelease(fullImage);
        } else {
            self.imageView.image = nil;
        }
    }
    
    // Set selection state
    self.selectionOverlay.hidden = !isSelected;
}

@end

#pragma mark - CIFilmStripView

@interface CIFilmStripView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation CIFilmStripView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor systemBackgroundColor];
    
    // Create collection view layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(80, 80);
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
    
    // Create collection view
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Register cell
    [self.collectionView registerClass:[CIFilmStripCell class] forCellWithReuseIdentifier:CIFilmStripCellIdentifier];
    
    [self addSubview:self.collectionView];
    
    // Constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    // Initialize with empty arrays
    self.assets = @[];
}

- (void)updateAssets:(NSArray<CIAsset *> *)assets selectedAsset:(nullable CIAsset *)selectedAsset {
    self.assets = [assets copy];
    self.selectedAsset = selectedAsset;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CIFilmStripCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CIFilmStripCellIdentifier forIndexPath:indexPath];
    
    CIAsset *asset = self.assets[indexPath.item];
    BOOL isSelected = [asset isEqual:self.selectedAsset];
    
    [cell configureWithAsset:asset isSelected:isSelected];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CIAsset *asset = self.assets[indexPath.item];
    
    if ([self.delegate respondsToSelector:@selector(filmStripView:didSelectAsset:)]) {
        [self.delegate filmStripView:self didSelectAsset:asset];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

@end
