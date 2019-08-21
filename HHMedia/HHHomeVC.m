//
//  HHHomeVC.m
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import "HHHomeVC.h"

#import "HHAuth.h"
#import "HHSelectImagesVC.h"
#import "HHSingleVideoPalyVc.h"
#import "HHImageToVideo.h"

@interface HHHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation HHHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    [self createUI];
    
}

#pragma mark ---------event
#pragma mark ---------private fountion

- (void)photosImagesToVideo{
    
    __weak typeof(self)weakSelf = self;
    
    [HHAuth checkAlbumPermission:^{
        //选择相片
        HHSelectImagesVC *imageSelectVc = [[HHSelectImagesVC alloc] init];
        imageSelectVc.title = @"相机胶卷";
//        imageSelectVc.limitNum = 100;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:imageSelectVc] animated:YES completion:nil];
        //已经选择的相片
        imageSelectVc.sureBlock = ^(NSMutableArray * _Nonnull selectImageArray) {
            //相片合成视频
            HHImageToVideo *imageToVideo = [[HHImageToVideo alloc] init];
            [imageToVideo compressionVideoForImageArray:selectImageArray progress:^(CGFloat progress) {
                
                DLog(@"%.1f",progress);
                
            } success:^(NSString * _Nonnull movePath) {
                //合成视频后播放
                HHSingleVideoPalyVc *videoPlayVc = [[HHSingleVideoPalyVc alloc] init];
                videoPlayVc.movePath = movePath;
                
                [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:videoPlayVc] animated:YES completion:nil];
                
            } failue:^(NSError * _Nonnull error) {
                
            }];
        };
    }];
}

#pragma mark ---------netWorking
#pragma mark ---------costomerDelegate
#pragma mark ---------systemDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self photosImagesToVideo];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ---------set get
#pragma mark ---------UI
- (void)createUI{
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [UIView new];
}
#pragma mark ---------lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 50.0f;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
    }
    
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"相片组成视频",@"视频编辑",@"本地视频管理",@"本地音频管理"];
    }
    return _dataArray;
}

@end
