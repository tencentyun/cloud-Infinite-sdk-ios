//
//  CIAdjustViewController.m
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import "CIAdjustViewController.h"

@interface CIAdjustViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *controlsStackView;
@property (nonatomic, strong) CIAdjustment *currentAdjustment;
@end

@implementation CIAdjustViewController

- (instancetype)initWithEditedAsset:(CIEditedAsset *)editedAsset {
    self = [super init];
    if (self) {
        _editedAsset = editedAsset;
        _currentAdjustment = [[CIAdjustment alloc] initWithAdjustment:editedAsset.adjustment];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Adjust Image";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupNavigationBar];
    [self setupUI];
    [self updateImageView];
}

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                          target:self 
                                                                                          action:@selector(cancelTapped:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                           target:self 
                                                                                           action:@selector(doneTapped:)];
}

- (void)setupUI {
    // Create scroll view
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    // Create image view with HDR support
    self.imageView = [[UIImageView alloc] init];
    self.imageView.preferredImageDynamicRange = UIImageDynamicRangeHigh;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create controls
    [self setupControls];
    
    // Create main stack view
    UIStackView *mainStackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.imageView, self.controlsStackView
    ]];
    mainStackView.axis = UILayoutConstraintAxisVertical;
    mainStackView.spacing = 20;
    mainStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.scrollView addSubview:mainStackView];
    
    // Setup constraints
    [NSLayoutConstraint activateConstraints:@[
        // Scroll view constraints
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        
        // Main stack view constraints
        [mainStackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:16],
        [mainStackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:16],
        [mainStackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-16],
        [mainStackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-16],
        [mainStackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor constant:-32],
        
        // Image view constraints
        [self.imageView.heightAnchor constraintEqualToConstant:300]
    ]];
}

- (void)setupControls {
    // Exposure control
    UIView *exposureControl = [self createSliderControlWithTitle:@"Exposure" 
                                                       minValue:-2.0 
                                                       maxValue:2.0 
                                                   initialValue:self.currentAdjustment.exposure 
                                                         target:self 
                                                         action:@selector(exposureChanged:)];
    self.exposureSlider = [self findSliderInView:exposureControl];
    
    // Contrast control
    UIView *contrastControl = [self createSliderControlWithTitle:@"Contrast" 
                                                       minValue:0.0 
                                                       maxValue:2.0 
                                                   initialValue:self.currentAdjustment.contrast 
                                                         target:self 
                                                         action:@selector(contrastChanged:)];
    self.contrastSlider = [self findSliderInView:contrastControl];
    
    // Saturation control
    UIView *saturationControl = [self createSliderControlWithTitle:@"Saturation" 
                                                         minValue:0.0 
                                                         maxValue:2.0 
                                                     initialValue:self.currentAdjustment.saturation 
                                                           target:self 
                                                           action:@selector(saturationChanged:)];
    self.saturationSlider = [self findSliderInView:saturationControl];
    
    // Sepia control
    UIView *sepiaControl = [self createSliderControlWithTitle:@"Sepia" 
                                                    minValue:0.0 
                                                    maxValue:1.0 
                                                initialValue:self.currentAdjustment.sepia 
                                                      target:self 
                                                      action:@selector(sepiaChanged:)];
    self.sepiaSlider = [self findSliderInView:sepiaControl];
    
    // Create controls stack view
    self.controlsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        exposureControl, contrastControl, saturationControl, sepiaControl
    ]];
    self.controlsStackView.axis = UILayoutConstraintAxisVertical;
    self.controlsStackView.spacing = 16;
    self.controlsStackView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (UIView *)createSliderControlWithTitle:(NSString *)title 
                                minValue:(float)minValue 
                                maxValue:(float)maxValue 
                            initialValue:(double)initialValue 
                                  target:(id)target 
                                  action:(SEL)action {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = minValue;
    slider.maximumValue = maxValue;
    slider.value = (float)initialValue;
    [slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = [NSString stringWithFormat:@"%.2f", initialValue];
    valueLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightRegular];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.tag = 100; // Tag to identify value label
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[label, slider, valueLabel]];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 12;
    stackView.alignment = UIStackViewAlignmentCenter;
    
    [NSLayoutConstraint activateConstraints:@[
        [label.widthAnchor constraintEqualToConstant:80],
        [valueLabel.widthAnchor constraintEqualToConstant:50]
    ]];
    
    return stackView;
}

- (UISlider *)findSliderInView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UISlider class]]) {
            return (UISlider *)subview;
        } else if ([subview isKindOfClass:[UIStackView class]]) {
            UISlider *slider = [self findSliderInView:subview];
            if (slider) return slider;
        }
    }
    return nil;
}

- (void)updateValueLabel:(UISlider *)slider {
    UIView *parentView = slider.superview;
    UILabel *valueLabel = [parentView viewWithTag:100];
    if (valueLabel && [valueLabel isKindOfClass:[UILabel class]]) {
        valueLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
    }
}

- (void)updateImageView {
    [self.editedAsset updateAdjustment:self.currentAdjustment];
    
    CIImage *renderedImage = self.editedAsset.renderedImage;
    if (renderedImage) {
        CGImageRef cgImage = [self.editedAsset.renderer createCGImage:renderedImage];
        if (cgImage) {
            self.imageView.image = [UIImage imageWithCGImage:cgImage];
            CGImageRelease(cgImage);
        }
    }
}

#pragma mark - Slider Actions

- (void)exposureChanged:(UISlider *)slider {
    self.currentAdjustment.exposure = slider.value;
    [self updateValueLabel:slider];
    [self updateImageView];
}

- (void)contrastChanged:(UISlider *)slider {
    self.currentAdjustment.contrast = slider.value;
    [self updateValueLabel:slider];
    [self updateImageView];
}

- (void)saturationChanged:(UISlider *)slider {
    self.currentAdjustment.saturation = slider.value;
    [self updateValueLabel:slider];
    [self updateImageView];
}

- (void)sepiaChanged:(UISlider *)slider {
    self.currentAdjustment.sepia = slider.value;
    [self updateValueLabel:slider];
    [self updateImageView];
}

#pragma mark - Navigation Actions

- (void)cancelTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneTapped:(UIBarButtonItem *)sender {
    [self.editedAsset updateAdjustment:self.currentAdjustment];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
