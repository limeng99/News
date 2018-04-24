//
//  MeViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "MeViewController.h"
#import "MyHeaderView.h"
#import "CollectViewController.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self prepareUI];
}

- (void)prepareUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    MyHeaderView *headerView = [[MyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.6*SCREEN_WIDTH)];
    _tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的收藏";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"我的浏览记录";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"我的通知";
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"帮助与反馈";
    }else{
        cell.textLabel.text = @"拨打客服电话";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        CollectViewController *collectVC = [[CollectViewController alloc] init];
        collectVC.title = @"我的收藏";
        [self.navigationController pushViewController:collectVC animated:YES];
    }
}



@end
