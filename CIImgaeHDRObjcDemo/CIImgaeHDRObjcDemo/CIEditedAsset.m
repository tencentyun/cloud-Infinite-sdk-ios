//
//  CIEditedAsset.m
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import "CIEditedAsset.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface CIEditedAsset ()
@property (nonatomic, strong, readwrite) CIAsset *asset;
@property (nonatomic, strong, readwrite) CIAdjustment *adjustment;
@property (nonatomic, strong, readwrite) CIRenderer *renderer;
@property (nonatomic, strong, readwrite, nullable) PHContentEditingInput *editingInput;
@property (nonatomic, strong, readwrite, nullable) PHContentEditingOutput *editingOutput;
@property (nonatomic, strong) CIImage *originalImage;
@end

@implementation CIEditedAsset

- (instancetype)initWithAsset:(CIAsset *)asset renderer:(CIRenderer *)renderer {
    self = [super init];
    if (self) {
        _asset = asset;
        _renderer = renderer;
        _adjustment = [[CIAdjustment alloc] init];
        [self loadOriginalImage];
    }
    return self;
}

- (void)loadOriginalImage {
    if (self.asset.file) {
        self.originalImage = [CIImage imageWithContentsOfURL:self.asset.file];
    } else if (self.asset.data) {
        self.originalImage = [CIImage imageWithData:self.asset.data];
    }
}

- (NSString *)defaultFilename {
    NSString *baseName = @"edited_image";
    
    if (self.asset.file) {
        NSString *originalName = [self.asset.file.lastPathComponent stringByDeletingPathExtension];
        baseName = [NSString stringWithFormat:@"%@_edited", originalName];
    } else if (self.asset.identifier) {
        baseName = [NSString stringWithFormat:@"%@_edited", self.asset.identifier];
    }
    
    return [baseName stringByAppendingPathExtension:@"jpg"];
}

- (nullable CIImage *)renderedImage {
    if (!self.originalImage) {
        return nil;
    }
    
    return [self.renderer renderImage:self.originalImage withAdjustment:self.adjustment];
}

- (void)updateAdjustment:(CIAdjustment *)adjustment {
    self.adjustment = [[CIAdjustment alloc] initWithAdjustment:adjustment];
    
    if ([self.delegate respondsToSelector:@selector(editedAsset:didUpdateAdjustment:)]) {
        [self.delegate editedAsset:self didUpdateAdjustment:self.adjustment];
    }
}

- (void)resetAdjustments {
    self.adjustment = [[CIAdjustment alloc] init];
    
    if ([self.delegate respondsToSelector:@selector(editedAsset:didUpdateAdjustment:)]) {
        [self.delegate editedAsset:self didUpdateAdjustment:self.adjustment];
    }
}

- (void)exportToURL:(NSURL *)url completion:(void (^)(BOOL success, NSError * _Nullable error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIImage *renderedImage = self.renderedImage;
        if (!renderedImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"CIEditedAssetErrorDomain" 
                                                     code:1001 
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Failed to render image"}];
                completion(NO, error);
            });
            return;
        }
        
        CGImageRef cgImage = [self.renderer createCGImage:renderedImage];
        if (!cgImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"CIEditedAssetErrorDomain" 
                                                     code:1002 
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Failed to create CGImage"}];
                completion(NO, error);
            });
            return;
        }
        
        CFMutableDataRef data = CFDataCreateMutable(NULL, 0);
        CGImageDestinationRef destination = CGImageDestinationCreateWithData(data, (__bridge CFStringRef)UTTypeJPEG.identifier, 1, NULL);
        
        if (!destination) {
            CGImageRelease(cgImage);
            CFRelease(data);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"CIEditedAssetErrorDomain" 
                                                     code:1003 
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Failed to create image destination"}];
                completion(NO, error);
            });
            return;
        }
        
        NSDictionary *options = @{
            (__bridge NSString *)kCGImageDestinationLossyCompressionQuality: @0.9
        };
        
        CGImageDestinationAddImage(destination, cgImage, (__bridge CFDictionaryRef)options);
        BOOL success = CGImageDestinationFinalize(destination);
        
        if (success) {
            NSError *writeError = nil;
            success = [(__bridge NSData *)data writeToURL:url options:NSDataWritingAtomic error:&writeError];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(success, writeError);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"CIEditedAssetErrorDomain" 
                                                     code:1004 
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Failed to finalize image destination"}];
                completion(NO, error);
            });
        }
        
        CGImageRelease(cgImage);
        CFRelease(destination);
        CFRelease(data);
    });
}

- (nullable NSData *)exportToJPEGData {
    return [self.renderer renderToJPEGData:self.originalImage withAdjustment:self.adjustment];
}

- (void)prepareForPhotoLibraryEdit:(void (^)(BOOL success))completion {
    if (!self.asset.photoAsset) {
        completion(NO);
        return;
    }
    
    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    
    [self.asset.photoAsset requestContentEditingInputWithOptions:options 
                                               completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentEditingInput) {
                self.editingInput = contentEditingInput;
                
                // Create editing output
                self.editingOutput = [[PHContentEditingOutput alloc] initWithContentEditingInput:contentEditingInput];
                
                // Load the full resolution image
                if (contentEditingInput.fullSizeImageURL) {
                    self.originalImage = [CIImage imageWithContentsOfURL:contentEditingInput.fullSizeImageURL];
                }
                
                completion(YES);
            } else {
                completion(NO);
            }
        });
    }];
}

@end
