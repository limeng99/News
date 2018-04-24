//
//  LocaViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/18.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "LocalViewController.h"
#import "DataBase.h"
#import "State.h"
#import "City.h"
#import "UIBarButtonItem+gyh.h"
#import "LocalHeaderView.h"

@interface LocalViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;

@property (nonatomic, strong) NSMutableArray *filterStateArray;
@property (nonatomic, strong) NSMutableArray *filterCityArray;

@end

@implementation LocalViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:[DataBase getStates]];
    }
    return _dataArray;
}

- (NSMutableArray *)filterCityArray
{
    if (!_filterCityArray) {
        _filterCityArray = [NSMutableArray array];
    }
    return _filterCityArray;
}

- (NSMutableArray *)filterStateArray
{
    if (!_filterStateArray) {
        _filterStateArray = [NSMutableArray array];
    }
    return _filterStateArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareTableView];
    [self prepareSearchBar];
}

- (void)prepareTableView
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"night_icon_back" highIcon:nil target:self action:@selector(back)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)prepareSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _searchBar.placeholder = @"搜索城市";
    _searchBar.delegate = self;
    _searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(5, 0);
    _tableView.tableHeaderView = _searchBar;
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView)
        return self.dataArray.count;
    return self.filterStateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        State *state = self.dataArray[section];
        return state.citys.count;
    }
    NSArray *array = self.filterCityArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (tableView == _tableView) {
        State *state = self.dataArray[indexPath.section];
        City *city = state.citys[indexPath.row];
        cell.textLabel.text = city.cityName;
    } else {
        NSArray *array = self.filterCityArray[indexPath.section];
        cell.textLabel.text = array[indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LocalHeaderView *headerView = [LocalHeaderView headerWithTableView:tableView];
    if (tableView == _tableView) {
        headerView.state = self.dataArray[section];
    } else {
        headerView.state = self.filterStateArray[section];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_tableView == tableView) {
        State *state = self.dataArray[indexPath.section];
        City *city = state.citys[indexPath.row];
        if (self.loclViewControllerBlock) {
            self.loclViewControllerBlock(state.stateName, city.cityName);
        }
    } else {
        State *state = self.filterStateArray[indexPath.section];
        NSArray *array = self.filterCityArray[indexPath.section];
        if (self.loclViewControllerBlock) {
            self.loclViewControllerBlock(state.stateName, array[indexPath.row]);
        }
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -UISearchBarDelegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(nonnull UITableView *)tableView
{
    tableView.tableHeaderView = [[UIView alloc] init];
//    tableView.style
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.filterStateArray removeAllObjects];
    [self.filterCityArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",_searchDisplayController.searchBar.text];
    for (State *state in self.dataArray) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (City *city in state.citys) {
            [tempArr addObject:city.cityName];
        }
        NSArray *filters = [tempArr filteredArrayUsingPredicate:predicate];
        if (filters.count) {
            [self.filterStateArray addObject:state];
            [self.filterCityArray addObject:filters];
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.filterStateArray removeAllObjects];
    [self.filterCityArray removeAllObjects];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for (id cencelButton in [searchBar.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
}


@end

