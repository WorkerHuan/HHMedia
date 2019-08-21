//
//  HHPHAsset.m
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHPHAsset.h"

@implementation HHPHAsset
+ (PHImageRequestID)hh_requestImageForAsset:(PHAsset *)asset
                                 withOption:(PHImageRequestOptions *)option isThumImage:(BOOL)isThumImage
                                 completion:(void (^)(UIImage *image))completion{
    
    @autoreleasepool {
        
        
        CGFloat width  = (CGFloat)asset.pixelWidth;
        CGFloat height = (CGFloat)asset.pixelHeight;
        CGFloat scale = width/height;
        CGSize targetSize = CGSizeMake(SCREEN_HEIGHT*scale, SCREEN_HEIGHT);
        if (isThumImage) {
            targetSize = CGSizeMake((SCREEN_WIDTH-16-9)/4.0, (SCREEN_WIDTH-16-9)/4.0);
        }
        
        return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                completion(result);
            }
        }];
        
    }
    
}
@end
