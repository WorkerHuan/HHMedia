//
//  HHAuth.m
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHAuth.h"
#import <Photos/Photos.h>
@implementation HHAuth
+(void)checkCameraPermission:(void(^)(void))successBlock{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self takePhoto:successBlock];
            }
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        //        [self alertCamear];
    } else {
        [self takePhoto:successBlock];
    }
}

+ (void)takePhoto:(void(^)(void))successBlock {
    //判断相机是否可用，防止模拟器点击【相机】导致崩溃
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        successBlock();
//        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:self.imagePickerController animated:YES completion:^{
//
//        }];
    } else {
        DLog(@"不能使用模拟器进行拍照");
    }
}

+(void)checkAlbumPermission:(void(^)(void))successBlock{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
//                    [self selectAlbum];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        successBlock();
                    }
                }
            });
        }];
    } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        [self alertAlbum:successBlock];
    } else {
//        [self selectAlbum];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            successBlock();
        }
    }
}

+ (void)alertAlbum:(void(^)(void))successBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [HHTopViewControl dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [HHTopViewControl presentViewController:alert animated:YES completion:nil];
}

@end
