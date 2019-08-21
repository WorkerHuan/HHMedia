//
//  HHBrowserVC.h
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPHAsset.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HHBrowserDelegate <NSObject>

@required

- (void)hh_willDisplayBrowserForIndex:(NSInteger)index ofImageView:(UIImageView *)imageView;
@optional

- (void)hh_browserScrollForIndex:(NSInteger)index;
//当前top的数组，0表示为选择
- (NSInteger)hh_browserTopViewIsSelectScrollForIndex:(NSInteger)index;
//返回选择按钮数字
- (NSInteger)hh_browserTopViewClickForIndex:(NSInteger)index;

//当界面滑动了当前界面，返回当前asset
- (HHPHAsset *)hh_browserScrollForBottomIndex:(NSInteger)index;


@end

typedef NS_ENUM(NSUInteger, SRBrowserViewType) {
    HHBrowserTypeForSelect,
    HHBrowserTypeForTopAndBottom,
};



@interface HHBrowserVC : UIViewController

@property (nonatomic, weak) id<HHBrowserDelegate> delegate;

@property (nonatomic,assign) SRBrowserViewType type;
//将要展示的数量
@property (nonatomic,assign) NSInteger willCount;

@property (nonatomic,assign) NSInteger currentIndex;
//选择当前状态显示数字
@property (nonatomic,assign) NSInteger currentShowNumber;

@property (nonatomic,strong) HHPHAsset *currentAsset;

@property (nonatomic,strong) NSMutableArray<HHPHAsset *> *bottomArray;

@property (nonatomic,copy) void(^sureBlock)(void);

@end

NS_ASSUME_NONNULL_END
