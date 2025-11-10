//
//  CIAsset.m
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import "CIAsset.h"
#import <ImageIO/ImageIO.h>

@interface CIAsset ()
@property (nonatomic, strong, readwrite) NSString *identifier;
@property (nonatomic, strong, readwrite, nullable) NSURL *file;
@property (nonatomic, strong, readwrite, nullable) NSData *data;
@property (nonatomic, assign, readwrite, nullable) CGImageRef thumbnail;
@property (nonatomic, strong, readwrite, nullable) PHAsset *photoAsset;
@end

@implementation CIAsset

- (instancetype)initWithFile:(NSURL *)file {
    return [self initWithFile:file thumbnail:nil];
}

- (instancetype)initWithFile:(NSURL *)file thumbnail:(nullable CGImageRef)thumbnail {
    self = [super init];
    if (self) {
        _identifier = [file.absoluteString copy];
        _file = file;
        _data = nil;
        _thumbnail = thumbnail;
        if (thumbnail) {
            CGImageRetain(thumbnail);
        }
        _photoAsset = nil;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data thumbnail:(nullable CGImageRef)thumbnail identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _file = nil;
        _data = data;
        _thumbnail = thumbnail;
        if (thumbnail) {
            CGImageRetain(thumbnail);
        }
        
        // Try to find corresponding PHAsset
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
        _photoAsset = assets.firstObject;
    }
    return self;
}

- (instancetype)initWithBundleResource:(NSString *)name withExtension:(NSString *)ext {
    self = [super init];
    if (self) {
        _identifier = [NSString stringWithFormat:@"bundle_%@.%@", name, ext];
        NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:ext];
        if (url) {
            _file = url;
            _data = nil;
        } else {
            _file = nil;
            _data = nil;
        }
        _thumbnail = nil;
        _photoAsset = nil;
    }
    return self;
}

+ (nullable CIAsset *)loadFromURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, nil);
    if (!source) {
        return nil;
    }
    
    CGImageRef thumbnail = [self loadThumbnailFromSource:source];
    CFRelease(source);
    
    CIAsset *asset = [[CIAsset alloc] initWithFile:url thumbnail:thumbnail];
    
    if (thumbnail) {
        CGImageRelease(thumbnail);
    }
    
    return asset;
}

+ (nullable CIAsset *)loadFromData:(NSData *)data identifier:(NSString *)identifier {
    if (!data || !identifier) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    if (!source) {
        return [[CIAsset alloc] initWithData:data thumbnail:nil identifier:identifier];
    }
    
    CGImageRef thumbnail = [self loadThumbnailFromSource:source];
    CFRelease(source);
    
    CIAsset *asset = [[CIAsset alloc] initWithData:data thumbnail:thumbnail identifier:identifier];
    
    if (thumbnail) {
        CGImageRelease(thumbnail);
    }
    
    return asset;
}

+ (nullable CIAsset *)loadFromBundle:(NSString *)resourceName withExtension:(NSString *)extension {
    if (!resourceName || !extension) {
        return nil;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resourceName withExtension:extension];
    if (!url) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, nil);
    if (!source) {
        return [[CIAsset alloc] initWithFile:url];
    }
    
    CGImageRef thumbnail = [self loadThumbnailFromSource:source];
    CFRelease(source);
    
    CIAsset *asset = [[CIAsset alloc] initWithFile:url thumbnail:thumbnail];
    
    if (thumbnail) {
        CGImageRelease(thumbnail);
    }
    
    return asset;
}

+ (nullable CGImageRef)loadThumbnailFromSource:(CGImageSourceRef)source {
    if (!source) {
        return nil;
    }
    
    // 添加HDR解码选项，这是关键！
    NSDictionary *options = @{
        (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
        (__bridge NSString *)kCGImageSourceCreateThumbnailWithTransform: @YES,
        (__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize: @400,
        (__bridge NSString *)kCGImageSourceDecodeRequest: (__bridge NSString *)kCGImageSourceDecodeToHDR
    };
    
    return CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)options);
}

- (nullable CGImageRef)loadFullImage {
    CGImageSourceRef source = nil;
    
    if (self.file) {
        source = CGImageSourceCreateWithURL((__bridge CFURLRef)self.file, nil);
    } else if (self.data) {
        source = CGImageSourceCreateWithData((__bridge CFDataRef)self.data, nil);
    }
    
    if (!source) {
        return nil;
    }
    
    // 添加HDR解码选项
    NSDictionary *options = @{
        (__bridge NSString *)kCGImageSourceDecodeRequest: (__bridge NSString *)kCGImageSourceDecodeToHDR
    };
    
    CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)options);
    CFRelease(source);
    
    return image;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CIAsset class]]) {
        return NO;
    }
    
    CIAsset *other = (CIAsset *)object;
    return [self.identifier isEqualToString:other.identifier];
}

- (NSUInteger)hash {
    return [self.identifier hash];
}

- (void)dealloc {
    if (_thumbnail) {
        CGImageRelease(_thumbnail);
    }
}

@end
