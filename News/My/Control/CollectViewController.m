//
//  CollectViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/19.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "CollectViewController.h"
#import "DataBase.h"
#import "DetailWebViewController.h"
#import "DataModel.h"
#import "CollectModel.h"

@interface CollectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CollectViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:[DataBase getCollects]];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataArray = nil;
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareUI];
}

- (void)prepareUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.rowHeight = 64;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CollectModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.time;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CollectModel *model = self.dataArray[indexPath.row];
    DetailWebViewController *detailVC = [[DetailWebViewController alloc] init];
    DataModel *dataModel = [[DataModel alloc] init];
    dataModel.docid = model.docid;
    dataModel.title = model.title;
    detailVC.dataModel = dataModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
