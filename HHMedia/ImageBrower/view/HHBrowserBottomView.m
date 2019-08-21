//
//  SRBrowserBottomView.m
//  BlueSeaRent
//
//  Created by llbt on 2019/5/23.
//  Copyright © 2019 yhb. All rights reserved.
//

#import "HHBrowserBottomView.h"



@interface HHBrowserBottomView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIButton *finishBtn;

@end
@implementation HHBrowserBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [HHBlackColor colorWithAlphaComponent:0.7];
        [self createUI];
    }
    return self;
}


- (void)finishAction{
    if (self.finishBlock) self.finishBlock();
}

- (void)setCurrentSRAsset:(HHPHAsset *)currentSRAsset{
    _currentSRAsset = currentSRAsset;
    [self.collectionView reloadData];
}

- (void)createUI{
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HHGrayColor;
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishBtn = finishBtn;
    finishBtn.titleLabel.font = HHFont(14);
    [finishBtn setTitleColor:HHWhiteColor forState:UIControlStateNormal];
    finishBtn.backgroundColor = HHColorWithHexString(@"#5AB4FA");
    finishBtn.layer.cornerRadius = 10;
    finishBtn.layer.masksToBounds = YES;
    
    [finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.collectionView];
    [self addSubview:lineView];
    [self addSubview:finishBtn];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_offset(0);
        make.height.mas_offset(70);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.top.equalTo(lineView.mas_bottom).offset(7);
        make.bottom.mas_offset(-7);
        make.width.mas_offset(71);
        make.height.mas_offset(28);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
    self.collectionView.hidden = (self.selectImgArray.count == 0);
    
//    [self.finishBtn setTitle:self.selectImgArray.count == 0?@"确定":[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectImgArray.count] forState:UIControlStateNormal];
    
    if (self.selectImgArray.count > 0) {
        
        self.finishBtn.enabled = YES;
        self.finishBtn.backgroundColor = HHColorWithHexString(@"#5AB4FA");
        [self.finishBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectImgArray.count] forState:UIControlStateNormal];
        
    }else{
        self.finishBtn.enabled = NO;
        [self.finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.finishBtn.backgroundColor = RGB(171, 217, 255);
    }

    
    return self.selectImgArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHBrowserBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HHBrowserBottomCell class]) forIndexPath:indexPath];
    
    HHPHAsset  *asset = self.selectImgArray[indexPath.row];
    
    if (asset.localImage) {
        cell.contentImgView.image = asset.localImage;
    }else{
        [HHPHAsset hh_requestImageForAsset:asset.asset withOption:nil isThumImage:NO completion:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.contentImgView.image = image;
            });
        }];
    }

    if (self.currentSRAsset == asset) {
        cell.contentView.layer.borderWidth = 1;
        cell.contentView.layer.borderColor = [UIColor greenColor].CGColor;
    }else{
        cell.contentView.layer.borderWidth = 0;
        
    }
    
    return cell;
    
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemW = 50 ;
        CGFloat itemH = 50 ;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.minimumLineSpacing = 9;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HHWhiteColor;
        
        /// 设置此属性为yes 不满一屏幕 也能滚动
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[HHBrowserBottomCell class] forCellWithReuseIdentifier:NSStringFromClass([HHBrowserBottomCell class])];
        
    }
    return _collectionView;
}


@end
