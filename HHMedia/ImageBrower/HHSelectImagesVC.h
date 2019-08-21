//
//  HHSelectImagesVC.h
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHSelectImagesVC : UIViewController

@property (nonatomic,copy) void(^sureBlock)(NSMutableArray *selectImageArray);

@property (nonatomic,assign) NSInteger limitNum;

@end

NS_ASSUME_NONNULL_END
