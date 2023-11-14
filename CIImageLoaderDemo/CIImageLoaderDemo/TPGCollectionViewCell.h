//
//  TPGCollectionViewCell.h
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/7/23.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <TPGImageView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPGCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@end

NS_ASSUME_NONNULL_END
