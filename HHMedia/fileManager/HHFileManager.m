//
//  HHFileManager.m
//  HHMedia
//
//  Created by llbt on 2019/8/20.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHFileManager.h"

NSString *const hh_Video = @"video";
NSString *const hh_Audio = @"audio";

@implementation HHFileManager

+ (NSString *)getWillStoragePathForType:(HHFileType)type{
    switch (type) {
        case HHFileTypeForVedio:
        {
            return [self getLocationCachePathWith:hh_Video Suffix:@"mov"];
        }
            break;
        case HHFileTypeForAudio:
        {
            return [self getLocationCachePathWith:hh_Audio Suffix:@"mp3"];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

+ (NSString *)getLocationCachePathWith:(NSString *)fileName Suffix:(NSString *)suffixString{
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileName];;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //获取当前时间戳作为文件名
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型

    
    NSString *newPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.%@",timeString,suffixString]];
    return newPath;
}
@end
