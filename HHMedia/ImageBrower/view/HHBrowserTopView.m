//
//  SRBrowserHeaderView.m
//  BlueSeaRent
//
//  Created by llbt on 2019/5/23.
//  Copyright © 2019 yhb. All rights reserved.
//

#import "HHBrowserTopView.h"
@interface HHBrowserTopView()
@property (nonatomic,strong) UIButton *selectBtn;
@end
@implementation HHBrowserTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [HHBlackColor colorWithAlphaComponent:0.7];
        [self createUI];
    }
    return self;
}

- (void)backAction{
    if(self.backBlock) self.backBlock();
}

- (void)selectAction:(id)sender{
    if(self.selectBlock) self.selectBlock();
}

- (void)setSelectNum:(NSInteger)selectNum{
    _selectNum = selectNum;
    if (selectNum == 0) {
        self.selectBtn.selected = NO;
        self.selectBtn.backgroundColor = HHClearColor;
        [self.selectBtn setImage:[UIImage imageNamed:@"image_noSelect"] forState:UIControlStateNormal];
        self.selectBtn.layer.cornerRadius = 0;
        self.selectBtn.layer.masksToBounds = NO;
        
    }else{
        self.selectBtn.selected = YES;
        [self.selectBtn setImage:nil forState:UIControlStateNormal];
        [self.selectBtn setTitle:[NSString stringWithFormat:@"%ld",(long)selectNum] forState:UIControlStateSelected];
        [self.selectBtn setTitleColor:HHWhiteColor forState:UIControlStateSelected];
        self.selectBtn.backgroundColor = HHColorWithHexString(@"#5AB4FA");
        self.selectBtn.layer.cornerRadius = 10;
        self.selectBtn.layer.masksToBounds = YES;
    }
}

- (void)createUI{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn = selectBtn;
    [selectBtn setImage:[UIImage imageNamed:@"image_noSelect"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backButton];
    [self addSubview:selectBtn];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.mas_offset(0);
    }];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.centerY.mas_offset(0);
        make.width.height.mas_offset(HHGetScalWidth(20));
    }];
    
    
}



@end
