//
//  SRPhotoBrowerCell.m
//  BlueSeaRent
//
//  Created by llbt on 2019/4/30.
//  Copyright © 2019 yhb. All rights reserved.
//

#import "HHBrowerCell.h"

@interface HHBrowerCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation HHBrowerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createUI];
        [self addGesture];
    }
    return self;
}

- (void)addGesture {
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapSingle:)];
    tapSingle.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapDouble:)];
    tapDouble.numberOfTapsRequired = 2;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPan:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    
    [tapSingle requireGestureRecognizerToFail:tapDouble];
    [tapSingle requireGestureRecognizerToFail:pan];
    [tapDouble requireGestureRecognizerToFail:pan];
    
    [self.scrollView addGestureRecognizer:tapSingle];
    [self.scrollView addGestureRecognizer:tapDouble];
//    [self.scrollView addGestureRecognizer:pan];
}

- (void)respondsToTapSingle:(UITapGestureRecognizer *)tap {
    if (self.tapSingleBlock) {
        self.tapSingleBlock();
    }
}
- (void)respondsToTapDouble:(UITapGestureRecognizer *)tap {
    
    UIScrollView *scrollView = self.scrollView;
//    UIView *zoomView = [self viewForZoomingInScrollView:scrollView];
//    CGPoint point = [tap locationInView:zoomView];
//    if (!CGRectContainsPoint(zoomView.bounds, point)) return;
    if (scrollView.zoomScale == scrollView.maximumZoomScale) {
        [scrollView setZoomScale:1 animated:YES];
    } else {
        [scrollView setZoomScale:3 animated:YES];
    }
    
}

- (void)respondsToPan:(UIPanGestureRecognizer *)pan {
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    self.cellData.zoomScale = scrollView.zoomScale;
    
//    CGRect imageViewFrame = self.displayImgView.frame;
//    CGFloat width = imageViewFrame.size.width,
//    height = imageViewFrame.size.height,
//    sHeight = scrollView.bounds.size.height,
//    sWidth = scrollView.bounds.size.width;
//    if (height > sHeight) {
//        imageViewFrame.origin.y = 0;
//    } else {
//        imageViewFrame.origin.y = (sHeight - height) / 2.0;
//    }
//    if (width > sWidth) {
//        imageViewFrame.origin.x = 0;
//    } else {
//        imageViewFrame.origin.x = (sWidth - width) / 2.0;
//    }
//    self.displayImgView.frame = imageViewFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.displayImgView;
}



- (void)createUI{
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.layer.masksToBounds = NO;
        
        [_scrollView setMinimumZoomScale:1];
        [_scrollView setMaximumZoomScale:3];
        [_scrollView setZoomScale:1 animated:YES];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UIImageView *displayImgView = [[UIImageView alloc] init];
        displayImgView.userInteractionEnabled = YES;
        displayImgView.contentMode = UIViewContentModeScaleAspectFit;

        self.displayImgView = displayImgView;
        [_scrollView addSubview:displayImgView];
        
        [displayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH);
            make.height.mas_offset(SCREEN_HEIGHT);
        }];
    }
    return _scrollView;
}

@end
