//
//  HHImageToVedio.h
//  HHMedia
//
//  Created by llbt on 2019/8/20.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHImageToVideo : NSObject

- (void)compressionVideoForImageArray:(NSArray *)imageArray progress:(void(^)(CGFloat progress))progressBlock success:(void(^)(NSString *movePath))successBlock failue:(void(^)(NSError *error))failueBlock;


@end

NS_ASSUME_NONNULL_END
