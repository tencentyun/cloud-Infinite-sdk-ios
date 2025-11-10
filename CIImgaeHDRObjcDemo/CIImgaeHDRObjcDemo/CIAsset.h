//
//  CIAsset.h
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIAsset : NSObject

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly, nullable) NSURL *file;
@property (nonatomic, strong, readonly, nullable) NSData *data;
@property (nonatomic, assign, readonly, nullable) CGImageRef thumbnail;
@property (nonatomic, strong, readonly, nullable) PHAsset *photoAsset;

// Initializers
- (instancetype)initWithFile:(NSURL *)file;
- (instancetype)initWithFile:(NSURL *)file thumbnail:(nullable CGImageRef)thumbnail;
- (instancetype)initWithData:(NSData *)data thumbnail:(nullable CGImageRef)thumbnail identifier:(NSString *)identifier;
- (instancetype)initWithBundleResource:(NSString *)name withExtension:(NSString *)ext;

// Static factory methods
+ (nullable CIAsset *)loadFromURL:(NSURL *)url;
+ (nullable CIAsset *)loadFromData:(NSData *)data identifier:(NSString *)identifier;
+ (nullable CIAsset *)loadFromBundle:(NSString *)resourceName withExtension:(NSString *)extension;

// Utility methods
- (nullable CGImageRef)loadFullImage;
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end

NS_ASSUME_NONNULL_END
