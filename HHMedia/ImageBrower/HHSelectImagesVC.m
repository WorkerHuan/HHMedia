//
//  HHSelectImagesVC.m
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHSelectImagesVC.h"

#import <Photos/Photos.h>
#import "HHSelectImagesCell.h"
#import "HHBrowserVC.h"
#import "HHPHAsset.h"

@interface HHSelectImagesVC ()<UICollectionViewDataSource,UICollectionViewDelegate,HHBrowserDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy) NSArray *assets;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) UIButton *preButton;
@property (nonatomic,copy) NSArray *preDisPlayArray;
@property (nonatomic,weak) HHBrowserVC *browserVc;
@property (nonatomic,strong) PHImageRequestOptions *option;
@property (nonatomic,assign) BOOL isFastScroll;//快速滑动

@property (nonatomic,assign) BOOL isFistComin;
@end

@implementation HHSelectImagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"相机胶卷";
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    [self fetchAssets];
    [self createUI];
}

- (void)cancelAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureAction{
    NSMutableArray *selectArray = [[NSMutableArray alloc] init];
    for (HHPHAsset *sr_asset in self.selectArray) {
        [selectArray addObject:sr_asset.localImage];
    }
    
    if (self.sureBlock) {
        self.sureBlock(selectArray);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (!self.isFistComin) {
        self.isFistComin = YES;
        
        if (self.assets.count > 0) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.assets.count-1) inSection:0];
            
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            //        self.isLoad = YES;
            //            [self.collectionView reloadData];
        }
        
    }
    
}

- (void)preButtonAction{
    [self openBrowser:nil currentIndex:0];
}

#pragma mark ---------private fountion
//获取相机数据
- (void)fetchAssets{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //    NSInteger limit = 8;
    
    options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
    
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    
    //    options.fetchLimit = limit;
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:options];
    NSMutableArray *assetModels = [[NSMutableArray alloc] init];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            HHPHAsset *asset = [[HHPHAsset alloc] init];
            asset.asset = obj;
            //            [assetModels addObject:asset];
            [assetModels insertObject:asset atIndex:0];
        } else {
            DLog(@"不属于图片-PHAssetMediaTypeImage");
        }
        
        
    }];
    
    self.assets = [assetModels copy];
    
    
    [self.collectionView reloadData];
}


- (void)openBrowser:(HHSelectImagesCell *)cell currentIndex:(NSInteger)currentIndex{
    HHBrowserVC *browserVc = [[HHBrowserVC alloc] init];
    self.browserVc = browserVc;
    browserVc.type = HHBrowserTypeForSelect;
    browserVc.delegate = self;
    
    NSMutableArray *displayArray = nil;
    if (cell) {
        displayArray = [[NSMutableArray alloc] initWithArray:self.assets];
    }else{
        displayArray = [NSMutableArray arrayWithArray:self.selectArray];
    }
    self.preDisPlayArray = displayArray;
    
    HHPHAsset *asset = self.preDisPlayArray[currentIndex];
    if ([self.selectArray containsObject:asset]) {
        NSInteger selectIndex = [self.selectArray indexOfObject:asset];
        
        browserVc.currentShowNumber = selectIndex+1;
        
    }else{
        browserVc.currentShowNumber = 0;
    }
    
    browserVc.currentAsset = asset;
    
    
    browserVc.willCount = displayArray.count;
    browserVc.bottomArray = cell?self.selectArray:displayArray;
    browserVc.currentIndex = currentIndex;
    WeakSelf(self);
    browserVc.sureBlock = ^{
        [weakSelf.browserVc dismissViewControllerAnimated:NO completion:nil];
        [weakSelf sureAction];
    };
    
    [self presentViewController:browserVc animated:YES completion:nil];
}



- (NSInteger)clickImageSelect:(NSInteger)currentIndex atArray:(NSArray *)atArray forIsCell:(HHSelectImagesCell *)cell{
    
    HHPHAsset *sr_asset = atArray[currentIndex];
    NSInteger num = 0;
    if (!sr_asset.isSelected) {
        if (self.selectArray.count == self.limitNum && self.limitNum != 0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"相片最多能选择%ld张",(long)self.limitNum] message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            if (cell) {
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                [self.browserVc presentViewController:alertController animated:YES completion:nil];
            }
            
            
            return 0;
        }
        
        sr_asset.isSelected = YES;
        [self.selectArray addObject:sr_asset];
        if (cell) {
            [self.collectionView reloadItemsAtIndexPaths:@[[self.collectionView indexPathForCell:cell]]];
        }else{
            num = self.selectArray.count;
        }
        [HHPHAsset hh_requestImageForAsset:sr_asset.asset withOption:self.option isThumImage:NO completion:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                sr_asset.localImage = image;
            });
        }];
        
    }else{
        
        sr_asset.isSelected = NO;
        //        sr_asset.localImage = nil;
        [self.selectArray removeObject:sr_asset];
        if (cell) {
            NSMutableArray *visArray = [[NSMutableArray alloc] init];
            for (UICollectionViewCell *viscell in self.collectionView.visibleCells) {
                NSIndexPath *visindexPath = [self.collectionView indexPathForCell:viscell];
                if (visindexPath) {
                    [visArray addObject:visindexPath];
                }
            }
            [self.collectionView reloadItemsAtIndexPaths:visArray];
        }else{
            
            num = 0;
        }
        
    }
    
    return num;
}



#pragma mark ---------netWorking
#pragma mark ---------costomerDelegate


- (void)hh_willDisplayBrowserForIndex:(NSInteger)index ofImageView:(UIImageView *)imageView{
    HHPHAsset *asset = self.preDisPlayArray[index];
    
    [HHPHAsset hh_requestImageForAsset:asset.asset withOption:self.option isThumImage:NO completion:^(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    }];
    
}
//当前top的数组，0表示为选择
- (NSInteger)hh_browserTopViewIsSelectScrollForIndex:(NSInteger)index{
    HHPHAsset *asset = self.preDisPlayArray[index];
    if ([self.selectArray containsObject:asset]) {
        NSInteger selectIndex = [self.selectArray indexOfObject:asset];
        
        return selectIndex+1;
        
    }else{
        return 0;
    }
}

- (void)hh_browserScrollForIndex:(NSInteger)index{
    
    
    
}

//返回选择按钮数字
- (NSInteger)hh_browserTopViewClickForIndex:(NSInteger)index{
    
    return [self clickImageSelect:index atArray:self.preDisPlayArray forIsCell:nil];
}

- (NSMutableArray<HHPHAsset *> *)hh_browserBottomNumberOfItems{
    return self.selectArray;
}

-(HHPHAsset *)hh_browserScrollForBottomIndex:(NSInteger)index{
    return self.preDisPlayArray[index];
}

#pragma mark ---------systemDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf(self);
    
    HHSelectImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HHSelectImagesCell class]) forIndexPath:indexPath];
    HHPHAsset  *asset = self.assets[indexPath.row];
    
    //    if (cell.requestId != 0) {
    //        [[PHImageManager defaultManager] cancelImageRequest:cell.requestId];
    //        cell.requestId = 0;
    //    }
    
    
    if(self.isFastScroll) {
        
        [HHPHAsset hh_requestImageForAsset:asset.asset withOption:self.option isThumImage:YES completion:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.iconImgView.image = image;
            });
            
        }];
        
        
        if ([self.selectArray containsObject:asset]) {
            NSInteger selectIndex = [self.selectArray indexOfObject:asset];
            
            cell.selectNum = selectIndex+1;
            
        }else{
            cell.selectNum = 0;
        }
        
        
    }else{
        
        [HHPHAsset hh_requestImageForAsset:asset.asset withOption:self.option isThumImage:NO completion:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.iconImgView.image = image;
            });
            
        }];
        
        
        if ([self.selectArray containsObject:asset]) {
            NSInteger selectIndex = [self.selectArray indexOfObject:asset];
            
            cell.selectNum = selectIndex+1;
            
        }else{
            cell.selectNum = 0;
        }
        
    }
    
    __weak typeof(cell)weakCell = cell;
    cell.selectBlock = ^{
        [weakSelf clickImageSelect:indexPath.row atArray:weakSelf.assets forIsCell:weakCell];
        
        if (weakSelf.selectArray.count > 0) {
            weakSelf.preButton.selected = YES;
            weakSelf.preButton.enabled = YES;
            weakSelf.sureButton.enabled = YES;
            weakSelf.sureButton.backgroundColor = HHColorWithHexString(@"#5AB4FA");
            [weakSelf.sureButton setTitle:[NSString stringWithFormat:@"  确定(%lu)  ",(unsigned long)weakSelf.selectArray.count] forState:UIControlStateNormal];
            
        }else{
            weakSelf.preButton.selected = NO;
            weakSelf.preButton.enabled = NO;
            weakSelf.preButton.enabled = NO;
            [weakSelf.sureButton setTitle:@"  确定  " forState:UIControlStateNormal];
            weakSelf.sureButton.backgroundColor = RGB(171, 217, 255);
        }
    };
    
    //    cell.contentImageView.image =
    return cell;
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self openBrowser:(HHSelectImagesCell *)[self.collectionView cellForItemAtIndexPath:indexPath] currentIndex:indexPath.row];
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    //    NSIndexPath *ip = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, targetContentOffset->y)];
    
    CGFloat ipY = targetContentOffset->y;
    CGFloat cipY = self.collectionView.contentOffset.y;
    //    CGFloat itemH = (SCREEN_WIDTH-16-9)/4.0;
    CGFloat skipH = SCREEN_HEIGHT - HHNavBarAndStatusBarHeight - 100;
    //取出当前展示的第一个cell的indexPath
    //    NSIndexPath *cip = [[self.collectionView indexPathsForVisibleItems] firstObject];
    //    NSInteger skipCount = self.collectionView.visibleCells.count;
    //如果两者之间差距很大则认为滑动速度很快，中间用户都不关心，直接把滚动停止时的展示的cell加入到needLoadArr数组中
    if (fabs(cipY-ipY)>skipH) {
        self.isFastScroll = YES;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    self.isFastScroll = NO;
    if (self.isFastScroll) {
        
        self.isFastScroll = NO;
        
        [self.collectionView reloadData];
        
    }
    
}


#pragma mark ---------set get
#pragma mark ---------UI
- (void)createUI{
    self.view.backgroundColor = HHWhiteColor;
    
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    self.collectionView.userInteractionEnabled = YES;
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-HHBottomSafeHeight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(HHGetScalHeight(77));
    }];
}
#pragma mark ---------lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemW = (SCREEN_WIDTH-16-9)/4.0;
        CGFloat itemH = (SCREEN_WIDTH-16-9)/4.0;
        layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
        
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.minimumInteritemSpacing = 3;
        layout.minimumLineSpacing = 3;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HHWhiteColor;
        [_collectionView registerClass:[HHSelectImagesCell class] forCellWithReuseIdentifier:NSStringFromClass([HHSelectImagesCell class])];
        
    }
    return _collectionView;
}


- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        //        _bottomView.backgroundColor = [LLBlackColor colorWithAlphaComponent:0.3];
        
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setTitle:@"预览" forState:UIControlStateNormal];
        [_preButton setTitle:@"预览" forState:UIControlStateSelected];
        [_preButton setTitleColor:HHBlackColor forState:UIControlStateSelected];
        [_preButton setTitleColor:HHColorWithHexString(@"#B2B2B2") forState:UIControlStateNormal];
        _preButton.titleLabel.font = HHFontNameSize(@"PingFang-SC-Regular", 14);
        [_preButton addTarget:self action:@selector(preButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitle:@"确定" forState:UIControlStateSelected];
        [_sureButton setTitleColor:HHWhiteColor forState:UIControlStateSelected];
        [_sureButton setTitleColor:HHWhiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = HHFontNameSize(@"PingFang-SC-Regular", 14);
        _sureButton.backgroundColor = RGB(171, 217, 255);
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        
        _sureButton.layer.cornerRadius = 14;
        _sureButton.layer.masksToBounds = YES;
        
        [_bottomView addSubview: _preButton];
        [_bottomView addSubview:_sureButton];
        
        [_preButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.centerY.mas_offset(0);
        }];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-15);
            make.centerY.mas_offset(0);
            make.width.mas_offset(HHGetScalWidth(71));
            make.height.mas_offset(HHGetScalHeight(28));
        }];
    }
    
    return _bottomView;
}

-(PHImageRequestOptions *)option{
    if (!_option) {
        _option = [[PHImageRequestOptions alloc] init];
        
        _option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        _option.resizeMode = PHImageRequestOptionsResizeModeExact;//控制照片尺寸
        _option.networkAccessAllowed = NO;
        _option.synchronous = NO;
    }
    return _option;
}


@end
