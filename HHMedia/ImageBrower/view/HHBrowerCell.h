//
//  SRPhotoBrowerCell.h
//  BlueSeaRent
//
//  Created by llbt on 2019/4/30.
//  Copyright © 2019 yhb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHBrowerCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *displayImgView;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,copy) void(^tapSingleBlock)(void);

@end

NS_ASSUME_NONNULL_END
