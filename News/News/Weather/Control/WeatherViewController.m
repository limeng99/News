//
//  WeatherViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherModel.h"
#import "WeatherHeaderView.h"
#import "WeatherBottomView.h"
#import "LocalViewController.h"

@interface WeatherViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WeatherHeaderView *headerView;
@property (nonatomic, strong) WeatherBottomView *bottomView;

@end

@implementation WeatherViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WeatherHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WeatherHeaderView alloc] init];
        __weak typeof(self) weakSelf = self;
        _headerView.backBlock = ^(void){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _headerView.localBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            LocalViewController *localVC = [[LocalViewController alloc] init];
            localVC.loclViewControllerBlock = ^(NSString *stateName, NSString *cityName) {
                [strongSelf.dataArray removeAllObjects];
                if ([stateName isEqualToString:@"热门城市"]) {
                    stateName = cityName;
                }
                [AppGlobal setProvince:stateName];
                [AppGlobal setCity:cityName];
                [strongSelf requestData];
            };
            localVC.title = [NSString stringWithFormat:@"当前城市 - %@", [AppGlobal getCity]];
            [weakSelf.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:localVC] animated:YES completion:nil];
        };
    }
    return _headerView;
}

- (WeatherBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[WeatherBottomView alloc] init];
    }
    return _bottomView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    [self requestData];
}

- (void)requestData
{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"http://c.3g.163.com/nc/weather/%@|%@.html",[AppGlobal getProvince],[AppGlobal getCity]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[HttpRequestHelper sharedHttpRequest] getRequestUrl:url setParams:nil didFinish:^(id json, NSError *error) {
        if (error == nil) {
            NSString *key = [NSString stringWithFormat:@"%@|%@",[AppGlobal getProvince],[AppGlobal getCity]];
            for (NSDictionary *dataDic in json[key]) {
                WeatherModel *model = [WeatherModel modelWithDictionary:json];
                [model modelSetWithDictionary:json[@"pm2d5"]];
                [model modelSetWithDictionary:dataDic];
                [weakSelf.dataArray addObject:model];
            }
            weakSelf.headerView.dataArray = weakSelf.dataArray;
            weakSelf.bottomView.dataArray = weakSelf.dataArray;
        }
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];

}

@end
