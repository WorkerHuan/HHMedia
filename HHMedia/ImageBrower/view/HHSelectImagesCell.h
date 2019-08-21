//
//  HHSelectImagesCell.h
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHSelectImagesCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *iconImgView;

@property (nonatomic,assign) NSInteger selectNum;/*!< 如果为0则是非选中状态 */

@property (nonatomic,copy) void(^selectBlock)();
@end

NS_ASSUME_NONNULL_END
