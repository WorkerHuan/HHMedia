//
//  HHPHAsset.h
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHPHAsset : NSObject

@property (strong, nonatomic) UIImage *localImage;

@property (strong, nonatomic) PHAsset *asset;

@property (assign, nonatomic) BOOL isSelected;

+ (PHImageRequestID)hh_requestImageForAsset:(PHAsset *)asset
                                 withOption:(PHImageRequestOptions *)option isThumImage:(BOOL)isThumImage
                                 completion:(void (^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
