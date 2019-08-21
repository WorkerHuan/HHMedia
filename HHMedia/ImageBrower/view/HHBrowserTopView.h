//
//  SRBrowserHeaderView.h
//  BlueSeaRent
//
//  Created by llbt on 2019/5/23.
//  Copyright © 2019 yhb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHBrowserTopView : UIView
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) NSInteger selectNum;

@property (nonatomic,copy) void(^backBlock)();
@property (nonatomic,copy) void(^selectBlock)();

@end

NS_ASSUME_NONNULL_END
