//
//  HHImageToVedio.m
//  HHMedia
//
//  Created by llbt on 2019/8/20.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHImageToVideo.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "HHFileManager.h"

@interface HHImageToVideo()

@end

@implementation HHImageToVideo

- (void)compressionVideoForImageArray:(NSArray *)imageArray progress:(void(^)(CGFloat progress))progressBlock success:(void(^)(NSString *movePath))successBlock failue:(void(^)(NSError *error))failueBlock{
    
    //设置mov路径
    
    NSString *moviePath = [HHFileManager getWillStoragePathForType:HHFileTypeForVedio];
    
    //    self.theVideoPath=moviePath;
    
    //定义视频的大小320 480 倍数
    CGSize size = CGSizeMake(320,480);
    
    NSError *error = nil;
    
    //    转成UTF-8编码
    unlink([moviePath UTF8String]);
    
    DLog(@"path->%@",moviePath);
    
    //     iphone提供了AVFoundation库来方便的操作多媒体设备，AVAssetWriter这个类可以方便的将图像和音频写成一个完整的视频文件
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:moviePath]fileType:AVFileTypeQuickTimeMovie error:&error];
    
    NSParameterAssert(videoWriter);
    
    if(error) {
        DLog(@"error =%@",[error localizedDescription]);
        if (failueBlock) failueBlock(error);
        return;
    }
    
    //mov的格式设置 编码格式 宽度 高度
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,
                                   
                                   [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                   
                                   [NSNumber numberWithInt:size.height],AVVideoHeightKey,nil];
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    
    //    AVAssetWriterInputPixelBufferAdaptor提供CVPixelBufferPool实例,
    //    可以使用分配像素缓冲区写入输出文件。使用提供的像素为缓冲池分配通常
    //    是更有效的比添加像素缓冲区分配使用一个单独的池
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    
    NSParameterAssert(writerInput);
    
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if([videoWriter canAddInput:writerInput]){
        
        DLog(@"11111");
        
    }else{
        
        DLog(@"22222");
        
    }
    
    [videoWriter addInput:writerInput];
    
    [videoWriter startWriting];
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //合成多张图片为一个视频文件
    
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue",NULL);
    
    int __block frame = 0;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        
        while([writerInput isReadyForMoreMediaData]) {
            
            if(++frame >= [imageArray count] * 10) {
                [writerInput markAsFinished];
                
                [videoWriter finishWritingWithCompletionHandler:^{
                    DLog(@"完成");
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        //                        self.ww_progressLbe.text = @"视频合成完毕";
                        //视屏完成
                        if (successBlock) successBlock(moviePath);
                    }];
                    
                }];
                break;
            }
            
            CVPixelBufferRef buffer = NULL;
            
            int idx = frame / 10;
            
            DLog(@"idx==%d",idx);
            CGFloat progress = idx / [imageArray count];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                //合成进度
                if (progressBlock) progressBlock(progress);
                
            }];
            
            
            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[imageArray objectAtIndex:idx]CGImage]size:size];
            
            if(buffer){
                
                //设置每秒钟播放图片的个数
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,10)]) {
                    
                    DLog(@"FAIL");
                    
                } else {
                    
                    DLog(@"OK");
                }
                
                CFRelease(buffer);
            }
        }
    }];
}

//视频合成按钮点击操作
- (void)compressionVedio {
    
    
    
    
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                             
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata !=NULL);
    
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    
    //    当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    
    //使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
    
    //    当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
    
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    
    // 释放色彩空间
    
    CGColorSpaceRelease(rgbColorSpace);
    
    // 释放context
    
    CGContextRelease(context);
    
    // 解锁pixel buffer
    
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
    
}


@end
