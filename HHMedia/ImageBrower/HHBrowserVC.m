//
//  HHBrowserVC.m
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHBrowserVC.h"

#import "HHBrowerCell.h"

#import "HHBrowserTopView.h"

#import "HHBrowserBottomView.h"

@interface HHBrowserVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) HHBrowserTopView *seletTopView;
@property (nonatomic,strong) HHBrowserBottomView *selectBottomView;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic,assign) NSInteger scrollIndex;

@property (nonatomic,assign) BOOL isFistComin;
@end

@implementation HHBrowserVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ((self.currentIndex < self.willCount) &&
        !self.isFistComin) {
        self.isFistComin = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        //        self.isLoad = YES;
        //        [self.collectionView reloadData];
    }
}

- (void)createUI{
    
    self.view.backgroundColor = HHBlackColor;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    if (self.type == HHBrowserTypeForSelect) {
        
        [self.view addSubview:self.seletTopView];
        [self.view addSubview:self.selectBottomView];
        
        self.selectBottomView.selectImgArray = self.bottomArray;
        
        
        
        [self.seletTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_offset(HHStatusBarHeight);
            make.height.mas_offset(44);
        }];
        
        [self.selectBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(-HHBottomSafeHeight);
            make.height.mas_offset(44+70);
        }];
        
        WeakSelf(self);
        self.seletTopView.selectBlock = ^{
            if ([weakSelf.delegate respondsToSelector:@selector(hh_browserTopViewClickForIndex:)]) {
                weakSelf.seletTopView.selectNum = [weakSelf.delegate hh_browserTopViewClickForIndex:weakSelf.scrollIndex];
                
            }
            [weakSelf.selectBottomView.collectionView reloadData];
        };
        
        self.seletTopView.backBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        self.selectBottomView.finishBlock = ^{
            
            if(weakSelf.sureBlock) weakSelf.sureBlock();
        };
        
    }else{
        
    }
    
    
    
}

-(void)setCurrentShowNumber:(NSInteger)currentShowNumber{
    _currentShowNumber = currentShowNumber;
    self.seletTopView.selectNum = currentShowNumber;
}

- (void)setCurrentAsset:(HHPHAsset *)currentAsset{
    _currentAsset = currentAsset;
    
    self.selectBottomView.currentSRAsset = currentAsset;
    
    [self.selectBottomView.collectionView reloadData];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.willCount;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HHBrowerCell class]) forIndexPath:indexPath];
    //    if (self.isLoad) {
    if ([self.delegate respondsToSelector:@selector(hh_willDisplayBrowserForIndex:ofImageView:)]) {
        [self.delegate hh_willDisplayBrowserForIndex:indexPath.row ofImageView:cell.displayImgView];
    }
    //    }
    
    [cell.scrollView setZoomScale:1];
    
    
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width;
    
    self.scrollIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(hh_browserScrollForIndex:)]) {
        [self.delegate hh_browserScrollForIndex:index];
    }
    if (self.type == HHBrowserTypeForSelect) {
        if ([self.delegate respondsToSelector:@selector(hh_browserTopViewIsSelectScrollForIndex:)]) {
            self.seletTopView.selectNum = [self.delegate hh_browserTopViewIsSelectScrollForIndex:index];
        }
        if ([self.delegate respondsToSelector:@selector(hh_browserScrollForBottomIndex:)]) {
            self.currentAsset = [self.delegate hh_browserScrollForBottomIndex:index];
        }
    }
    
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemW = SCREEN_WIDTH;
        CGFloat itemH = SCREEN_HEIGHT;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        /// 设置此属性为yes 不满一屏幕 也能滚动
        //        _collectionView.alwaysBounceHorizontal = YES;
        //        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        
        [_collectionView registerClass:[HHBrowerCell class] forCellWithReuseIdentifier:NSStringFromClass([HHBrowerCell class])];
        
    }
    return _collectionView;
}

- (HHBrowserTopView *)seletTopView{
    if (!_seletTopView) {
        _seletTopView = [[HHBrowserTopView alloc] init];
    }
    return _seletTopView;
}

- (HHBrowserBottomView *)selectBottomView{
    if (!_selectBottomView) {
        _selectBottomView = [[HHBrowserBottomView alloc] init];
    }
    return _selectBottomView;
}




@end
