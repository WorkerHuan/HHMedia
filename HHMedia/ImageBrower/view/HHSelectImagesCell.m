//
//  HHSelectImagesCell.m
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHSelectImagesCell.h"
@interface HHSelectImagesCell()

@property (nonatomic,strong) UIButton *selectBtn;
@end
@implementation HHSelectImagesCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
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

- (void)selectAction:(UIButton *)sender{
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (void)createUI{
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;
    self.iconImgView = imgView;
    //    imgView.image = [UIImage imageNamed:@"home_detail_bg"];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn = selectBtn;
    [selectBtn setImage:[UIImage imageNamed:@"image_noSelect"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:imgView];
    [self.contentView addSubview:selectBtn];
    
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.right.mas_offset(-5);
        make.width.height.mas_offset(HHGetScalWidth(20));
    }];
    
    
}

@end
