//
//  SRBrowserBottomView.h
//  BlueSeaRent
//
//  Created by llbt on 2019/5/23.
//  Copyright © 2019 yhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPHAsset.h"
#import "HHBrowserBottomCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface HHBrowserBottomView : UIView

@property (nonatomic,strong) UICollectionView *collectionView;


@property (nonatomic,strong) NSMutableArray *selectImgArray;
@property (nonatomic,copy) void(^finishBlock)();
@property (nonatomic,strong) HHPHAsset *currentSRAsset;

@end

NS_ASSUME_NONNULL_END
