//
//  HHAuth.h
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAuth : NSObject
//相机
+(void)checkCameraPermission:(void(^)(void))successBlock;
//相册
+(void)checkAlbumPermission:(void(^)(void))successBlock;
@end

NS_ASSUME_NONNULL_END
