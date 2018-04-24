//
//  VideoViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
#import "VideoCell.h"
#import "GYHHeadeRefreshController.h"
#import "GYPlayer.h"
#import "VideoHeaderView.h"
#import "ClassViewController.h"

@interface VideoViewController ()<UITableViewDelegate, UITableViewDataSource, GYPlayerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;

@property (nonatomic, strong) GYPlayer *player;
@property (nonatomic, assign) CGFloat currentOriginY;
@property (nonatomic, strong) NSIndexPath *playIndexPath;

@end

@implementation VideoViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.player removePlayer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];

    [self prepareUI];
}

- (void)prepareUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    VideoHeaderView *headerView = [[VideoHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.25)];
    _tableView.tableHeaderView = headerView;
    headerView.selectedBlock = ^(NSInteger index, NSString *title){
        NSArray *sources = @[@"VAP4BFE3U",@"VAP4BFR16",@"VAP4BG6DL",@"VAP4BGTVD"];
        DLog(@"sources ---- %@", sources[index]);
        ClassViewController *classVC = [[ClassViewController alloc] init];
        classVC.videoType = sources[index];
        classVC.title = title;
        [weakSelf.navigationController pushViewController:classVC animated:YES];
    };
    
    MJRefreshStateHeader *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        weakSelf.page = 0;
        [weakSelf requestData];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 10;
        [weakSelf requestData];
    }];
    
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%d-10.html",self.page];
    [[HttpRequestHelper sharedHttpRequest] getRequestUrl:url setParams:nil didFinish:^(id json, NSError *error) {
        if (error == nil) {
            for (NSDictionary *dic in json[@"videoList"]) {
                VideoData *model = [VideoData modelWithDictionary:dic];
                VideoDataFrame *videoFrame = [[VideoDataFrame alloc] init];
                videoFrame.videoData = model;
                [weakSelf.dataArray addObject:videoFrame];
            }
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    }];
}

// 获取当前高度
- (CGFloat)currentOriginY
{
    VideoCell *cell = [self.tableView cellForRowAtIndexPath:self.playIndexPath];
    CGRect absoluteRect =[cell convertRect:cell.bounds toView:AppWindow];
    CGFloat originY = self.tableView.contentOffset.y + absoluteRect.origin.y;
    return originY;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [VideoCell cellWithTableView:tableView];
    cell.videoFrame = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoFrame = _dataArray[indexPath.row];
    return videoFrame.cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    VideoDataFrame *videoFrame = _dataArray[indexPath.row];
    VideoData *videoData = videoFrame.videoData;
    //创建播放器
    if (self.player) {
        [self.player removePlayer];
    }
    self.playIndexPath = indexPath;
    self.player = [[GYPlayer alloc] initWithFrame:CGRectMake(0, self.currentOriginY, SCREEN_WIDTH, SCREEN_WIDTH * 0.56)];
    self.player.mp4_url = videoData.mp4_url;
    self.player.title = videoData.title;
    self.player.currentOriginY = self.currentOriginY;
    self.player.delegate = self;
    [self.player play];
    [self.tableView addSubview:self.player];
}

//判断滚动事件，如何超出播放界面，停止播放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"--------%f",scrollView.contentOffset.y );

    if (self.player) {
        
//        if (scrollView.contentOffset.y + 64 - (self.player.currentOriginY + SCREEN_WIDTH * 0.56) > 0){
//            NSLog(@"--------%f",scrollView.contentOffset.y - (self.player.currentOriginY + SCREEN_WIDTH * 0.56));
//            DLog(@"tttttttttttttttt");
//        }
//        if (self.player.currentOriginY - (scrollView.contentOffset.y + SCREEN_HEIGHT - 49) > 0) {
//            DLog(@"dddddddddddddddddd");
//        }
        
        if (scrollView.contentOffset.y + 64 - (self.player.currentOriginY + SCREEN_WIDTH * 0.56) > 0  || self.player.currentOriginY - (scrollView.contentOffset.y + SCREEN_HEIGHT - 49) > 0 ){
            [self.player beyondScreen];
        } else {
            NSSet *visiblecells = [NSSet setWithArray:[self.tableView indexPathsForVisibleRows]];
            if (![visiblecells containsObject:self.playIndexPath]) {
                return;
            }
            [self.player backScreen:self.tableView];
        }
    }
}

#pragma mark - GYPlayerDelegate
- (void)playerView:(GYPlayer *)playView didRemovePlay:(AVPlayer *)player
{
    playView = nil;
    self.player = nil;
}

- (void)playerView:(GYPlayer *)playView didExitFullScreen:(AVPlayer *)player
{
    [self.tableView addSubview:playView];
}

- (void)playerView:(GYPlayer *)playView didPlayEnd:(AVPlayer *)player
{
    [self.player removePlayer];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:self.playIndexPath.row + 1 inSection:self.playIndexPath.section];
    if (_dataArray[nextIndexPath.row]) {
        self.playIndexPath = nextIndexPath;
        [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self tableView:self.tableView didSelectRowAtIndexPath:nextIndexPath];
        [self.player autoFullScreenPlay];
    }
}

@end
