//
//  SRBrowserBottomCell.m
//  BlueSeaRent
//
//  Created by llbt on 2019/5/23.
//  Copyright © 2019 yhb. All rights reserved.
//

#import "HHBrowserBottomCell.h"

@implementation HHBrowserBottomCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIImageView *contentImgView = [[UIImageView alloc] init];
    contentImgView.contentMode = UIViewContentModeScaleAspectFill;
    contentImgView.layer.masksToBounds = YES;
    self.contentImgView = contentImgView;
    [self.contentView addSubview:contentImgView];
    
    [contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
}

@end
