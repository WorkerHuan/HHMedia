//
//  HHFileManager.h
//  HHMedia
//
//  Created by llbt on 2019/8/20.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHFileType) {
    HHFileTypeForVedio = 0,
    HHFileTypeForAudio,
};

@interface HHFileManager : NSObject
//获取将要存储的文件路径
+ (NSString *)getWillStoragePathForType:(HHFileType)type;

@end

NS_ASSUME_NONNULL_END
