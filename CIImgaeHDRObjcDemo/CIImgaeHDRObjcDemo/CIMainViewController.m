//
//  CIMainViewController.m
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import "CIMainViewController.h"
#import "CIImageViewController.h"
#import "CIAdjustViewController.h"

@interface CIMainViewController ()
@property (nonatomic, strong) UIStackView *buttonStackView;
@property (nonatomic, strong) UIStackView *mainStackView;
@end

@implementation CIMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"HDR Image Editor";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupRenderer];
    [self setupUI];
    [self loadDefaultImage];
}

- (void)setupRenderer {
    self.renderer = [[CIRenderer alloc] init];
    self.assets = [[NSMutableArray alloc] init];
}

- (void)setupUI {
    // Create image view
    self.imageView = [[UIImageView alloc] init];
    self.imageView.preferredImageDynamicRange = UIImageDynamicRangeHigh;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create film strip view
    self.filmStripView = [[CIFilmStripView alloc] init];
    self.filmStripView.delegate = self;
    self.filmStripView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create buttons
    [self setupButtons];
    
    // Create stack views
    self.buttonStackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.importButton, self.editButton, self.cancelButton, self.saveButton
    ]];
    self.buttonStackView.axis = UILayoutConstraintAxisHorizontal;
    self.buttonStackView.distribution = UIStackViewDistributionFillEqually;
    self.buttonStackView.spacing = 16;
    self.buttonStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.mainStackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.imageView, self.filmStripView, self.buttonStackView
    ]];
    self.mainStackView.axis = UILayoutConstraintAxisVertical;
    self.mainStackView.spacing = 16;
    self.mainStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.mainStackView];
    
    // Setup constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.mainStackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16],
        [self.mainStackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.mainStackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.mainStackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-16],
        
        [self.filmStripView.heightAnchor constraintEqualToConstant:100],
        [self.buttonStackView.heightAnchor constraintEqualToConstant:44]
    ]];
    
    [self updateUI];
}

- (void)setupButtons {
    // Import button
    self.importButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.importButton setTitle:@"Import" forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(importButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Edit button
    self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Cancel button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Save button
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateUI {
    CIAsset *currentAsset = self.selectedAsset ?: self.defaultAsset;
    
    // Update image view
    if (self.isEditing && self.editedAsset) {
        [self displayEditedImage];
    } else {
        [self displayAsset:currentAsset];
    }
    
    // Update film strip
    [self.filmStripView updateAssets:self.assets selectedAsset:self.selectedAsset];
    
    // Update button states
    BOOL hasAsset = (currentAsset != nil);
    
    self.editButton.enabled = hasAsset && !self.isEditing;
    self.cancelButton.enabled = self.isEditing;
    self.saveButton.enabled = self.isEditing;
    
    // Show/hide buttons based on editing state
    self.importButton.hidden = self.isEditing;
    self.editButton.hidden = self.isEditing;
    self.cancelButton.hidden = !self.isEditing;
    self.saveButton.hidden = !self.isEditing;
}

- (void)displayAsset:(nullable CIAsset *)asset {
    if (!asset) {
        self.imageView.image = nil;
        return;
    }
    
    if (asset.thumbnail) {
        self.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    } else {
        // Load full image if no thumbnail
        CGImageRef fullImage = [asset loadFullImage];
        if (fullImage) {
            self.imageView.image = [UIImage imageWithCGImage:fullImage];
            CGImageRelease(fullImage);
        }
    }
}

- (void)displayEditedImage {
    if (!self.editedAsset) {
        return;
    }
    
    CIImage *renderedImage = self.editedAsset.renderedImage;
    if (renderedImage) {
        CGImageRef cgImage = [self.renderer createCGImage:renderedImage];
        if (cgImage) {
            self.imageView.image = [UIImage imageWithCGImage:cgImage];
            CGImageRelease(cgImage);
        }
    }
}

- (void)loadDefaultImage {
    self.defaultAsset = [CIAsset loadFromBundle:@"湖面HDR" withExtension:@"jpg"];
    [self updateUI];
}

#pragma mark - Button Actions

- (void)importButtonTapped:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Import Image" 
                                                                   message:@"Choose import source" 
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPhotoPicker];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    // For iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = sender;
        alert.popoverPresentationController.sourceRect = sender.bounds;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)editButtonTapped:(UIButton *)sender {
    CIAsset *assetToEdit = self.selectedAsset ?: self.defaultAsset;
    if (!assetToEdit) {
        return;
    }
    
    self.editedAsset = [[CIEditedAsset alloc] initWithAsset:assetToEdit renderer:self.renderer];
    self.editedAsset.delegate = self;
    
    if (assetToEdit.photoAsset) {
        // Prepare for photo library editing
        [self.editedAsset prepareForPhotoLibraryEdit:^(BOOL success) {
            if (success) {
                [self presentAdjustViewController];
            } else {
                NSLog(@"Failed to prepare for photo library editing");
            }
        }];
    } else {
        // Direct editing for file-based assets
        [self presentAdjustViewController];
    }
}

- (void)cancelButtonTapped:(UIButton *)sender {
    self.isEditing = NO;
    self.editedAsset = nil;
    [self updateUI];
}

- (void)saveButtonTapped:(UIButton *)sender {
    if (!self.editedAsset) {
        return;
    }
    
    if (self.editedAsset.asset.photoAsset && self.editedAsset.editingOutput) {
        // Save to photo library
        [self saveToPhotoLibrary];
    } else {
        // Export to file
        [self presentDocumentExporter];
    }
}

#pragma mark - Presentation Methods

- (void)presentPhotoPicker {
    PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
    config.selectionLimit = 0; // 0 means no limit
    config.filter = [PHPickerFilter imagesFilter];
    
    PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)presentAdjustViewController {
    self.isEditing = YES;
    
    CIAdjustViewController *adjustVC = [[CIAdjustViewController alloc] initWithEditedAsset:self.editedAsset];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:adjustVC];
    
    [self presentViewController:navController animated:YES completion:nil];
    [self updateUI];
}

- (void)presentDocumentExporter {
    NSString *filename = self.editedAsset.defaultFilename;
    NSURL *tempURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:filename]];
    
    [self.editedAsset exportToURL:tempURL completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForExportingURLs:@[tempURL]];
            picker.delegate = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:picker animated:YES completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showErrorAlert:@"Export failed" message:error.localizedDescription];
            });
        }
    }];
}

- (void)saveToPhotoLibrary {
    // Implementation for saving to photo library
    // This would involve using PHPhotoLibrary.shared().performChanges
    NSLog(@"Saving to photo library - implementation needed");
    
    self.isEditing = NO;
    self.editedAsset = nil;
    [self updateUI];
}

- (void)showErrorAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - PHPickerViewControllerDelegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (results.count == 0) {
        return;
    }
    
    self.isImporting = YES;
    
    for (PHPickerResult *result in results) {
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                UIImage *image = (UIImage *)object;
                NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                
                if (imageData) {
                    CIAsset *asset = [CIAsset loadFromData:imageData identifier:result.assetIdentifier ?: [[NSUUID UUID] UUIDString]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.assets addObject:asset];
                        self.selectedAsset = asset;
                        [self updateUI];
                    });
                }
            }
        }];
    }
    
    self.isImporting = NO;
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    for (NSURL *url in urls) {
        CIAsset *asset = [CIAsset loadFromURL:url];
        if (asset) {
            [self.assets addObject:asset];
            self.selectedAsset = asset;
        }
    }
    [self updateUI];
}

#pragma mark - CIEditedAssetDelegate

- (void)editedAsset:(CIEditedAsset *)editedAsset didUpdateAdjustment:(CIAdjustment *)adjustment {
    [self updateUI];
}

- (void)editedAsset:(CIEditedAsset *)editedAsset didFinishWithAsset:(nullable CIAsset *)asset {
    if (asset) {
        // Replace the original asset with the edited one
        NSUInteger index = [self.assets indexOfObject:editedAsset.asset];
        if (index != NSNotFound) {
            [self.assets replaceObjectAtIndex:index withObject:asset];
            self.selectedAsset = asset;
        }
    }
    
    self.isEditing = NO;
    self.editedAsset = nil;
    [self updateUI];
}

#pragma mark - CIFilmStripViewDelegate

- (void)filmStripView:(CIFilmStripView *)filmStripView didSelectAsset:(CIAsset *)asset {
    self.selectedAsset = asset;
    [self updateUI];
}

@end
