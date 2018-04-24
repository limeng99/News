//
//  SocietyViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "SocietyViewController.h"
#import "SDCycleScrollView.h"
#import "TopBannerModel.h"
#import "TopBannerViewController.h"
#import "DataModel.h"
#import "NewsCell.h"
#import "ImagesCell.h"
#import "BigImageCell.h"
#import "DetailWebViewController.h"

@interface SocietyViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSMutableArray *topArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int page;
@end

@implementation SocietyViewController

- (NSMutableArray *)totalArray
{
    if (_totalArray == nil) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}

- (NSMutableArray *)topArray
{
    if (!_topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    [self initBannerView];
    [self requestTopData];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.totalArray removeAllObjects];
        weakSelf.page = 0;
        [weakSelf requestNewsData:1];
    }];
    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 20;
        [weakSelf requestNewsData:2];
    }];
    
}

- (void)initBannerView
{
    _bannerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH*0.55)];
    _bannerView.delegate = self;
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _tableView.tableHeaderView = _bannerView;
}

- (void)requestTopData
{
    __weak typeof(self) weakSelf = self;
    [[HttpRequestHelper sharedHttpRequest] getRequestUrl:@"http://c.3g.163.com/nc/article/headline/T1348647853363/0-10.html" setParams:nil didFinish:^(id json, NSError *error) {
        if (error == nil) {
            NSMutableArray *images = [NSMutableArray array];
            NSMutableArray *titles = [NSMutableArray array];
            for (NSDictionary *dic in json[@"T1348647853363"][0][@"ads"]) {
                TopBannerModel *model = [TopBannerModel modelWithDictionary:dic];
                [weakSelf.topArray addObject:model];
                [images addObject:model.imgsrc];
                [titles addObject:model.title];
            }
            _bannerView.imageURLStringsGroup = images;
            _bannerView.titlesGroup = titles;
        }
    }];
}

- (void)requestNewsData:(int)page
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-20.html",self.page];
    [[HttpRequestHelper sharedHttpRequest] getRequestUrl:url setParams:nil didFinish:^(id json, NSError *error) {
        if (error == nil) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dic in json[@"T1348647853363"]) {
                DataModel *model = [DataModel modelWithDictionary:dic];
                [tempArray addObject:model];
            }
            if (page == 1) {
                weakSelf.totalArray = tempArray;
            } else {
                [weakSelf.totalArray addObjectsFromArray:tempArray];
            }
            [_tableView reloadData];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    TopBannerModel *model = _topArray[index];
    NSArray * arr = [model.url componentsSeparatedByString:@"|"];
    if (arr.count) {
        TopBannerViewController *topVC = [[TopBannerViewController alloc] init];
        topVC.url = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",[arr[0] substringFromIndex:4],arr[1]];
        [self.navigationController pushViewController:topVC animated:YES];
    }
}

#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = self.totalArray[indexPath.row];
    NSString *ID = [NewsCell idForRow:model];
    if ([@"NewsCell" isEqualToString:ID]) {
        NewsCell *cell = [NewsCell cellWithTableView:tableView];
        cell.dataModel = model;
        return cell;
    } else if([@"ImagesCell" isEqualToString:ID]){
        ImagesCell *cell = [ImagesCell cellWithTableView:tableView];
        cell.dataModel = model;
        return cell;
    } else if([@"BigImageCell" isEqualToString:ID]){
        BigImageCell *cell = [BigImageCell cellWithTableView:tableView];
        cell.dataModel = model;
        return cell;
    } else {
        return [[UITableViewCell alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewsCell heightForRow:_totalArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DataModel *model = self.totalArray[indexPath.row];
    DetailWebViewController *detailVC = [[DetailWebViewController alloc] init];
    detailVC.dataModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
