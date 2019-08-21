//
//  HHSingleVideoPalyVc.m
//  HHMedia
//
//  Created by llbt on 2019/8/20.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHSingleVideoPalyVc.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface HHSingleVideoPalyVc ()

@end

@implementation HHSingleVideoPalyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    [self playAction];
}

- (void)cancelAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)playAction {
    
    // 文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:self.movePath]) {
        DLog(@"文件不存在");
        return;
    }
    
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:self.movePath];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    playerLayer.frame = CGRectMake(0, SCREEN_WIDTH * 0.25, SCREEN_WIDTH, SCREEN_HEIGHT * 0.65);
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerLayer];
    
    [player play];
    
}

@end
