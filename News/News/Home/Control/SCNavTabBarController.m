//
//  SCNavTabBarController.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "SCNavTabBarController.h"
#import "SocietyViewController.h"
#import "OtherNewsViewController.h"
#import "SCNavTabBar.h"
#import "WeatherViewController.h"

@interface SCNavTabBarController ()<SCNavTabBarDelegate, UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) SCNavTabBar *navTabBar;
@property (nonatomic, strong) UIScrollView *mainView;
@end

@implementation SCNavTabBarController

- (NSMutableArray *)subViewControllers
{
    if (_subViewControllers == nil) {
        _subViewControllers = [NSMutableArray array];
    }
    return _subViewControllers;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    DLog(@"%@",NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _currentIndex = 1;
    _titles = @[@"社会",@"精选",@"汽车",@"娱乐",@"体育",@"科技",@"奇闻趣事",@"生活健康"];
    
    [self viewConfig];
    [self initControl];
    
    AdjustsScrollViewInsetNever(self, self.mainView);
}

- (void)initControl
{
    SocietyViewController *oneVC = [[SocietyViewController alloc] init];
    oneVC.title = _titles[0];
    [_mainView addSubview:oneVC.view];
    [self addChildViewController:oneVC];
    [self.subViewControllers addObject:oneVC];
    
    NSArray *urls = @[@"shehui",
                      @"http://c.3g.163.com/nc/article/list/T1467284926140/0-20.html",
                      @"http://c.m.163.com/nc/auto/list/5bmz6aG25bGx/0-20.html",
                      @"http://c.3g.163.com/nc/article/list/T1348648517839/0-20.html",
                      @"http://c.3g.163.com/nc/article/list/T1348649079062/0-20.html",
                      @"keji",
                      @"qiwen",
                      @"health"];
    for (int i = 1; i < _titles.count; i++) {
        OtherNewsViewController *otherVC = [[OtherNewsViewController alloc] init];
        otherVC.title = _titles[i];
        otherVC.content = urls[i];
        [_subViewControllers addObject:otherVC];
    }
}

- (void)viewConfig
{
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight)];
    _navTabBar.backgroundColor = [UIColor whiteColor];
    _navTabBar.delegate = self;
    _navTabBar.lineColor = [UIColor redColor];
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateData];
    [self.view addSubview:_navTabBar];
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaTopHeight)];
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.pagingEnabled = YES;
    _mainView.delegate = self;
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH*_titles.count, 0);
    [self.view addSubview:_mainView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = RGBA(216, 216, 216, 1.0);
    [self.view addSubview:lineView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, SafeAreaStateHeight, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(weatherClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)weatherClick
{
    WeatherViewController *weatherVC = [[WeatherViewController alloc] init];
    [self.navigationController pushViewController:weatherVC animated:YES];
}

#pragma mark - SCNavTabBarDelegate
- (void)SCNavTabBar:(SCNavTabBar *)tabBar itemDidSelectedWithIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex
{
    if (abs((int)(currentIndex - index)) >= 2) {
        [_mainView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:NO];
    } else {
        [_mainView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _navTabBar.currentIndex = _currentIndex;
    
    UIViewController *currentViewController = _subViewControllers[_currentIndex];
    currentViewController.view.frame = CGRectMake(SCREEN_WIDTH * _currentIndex, 0, SCREEN_WIDTH, scrollView.frame.size.height);
    if(![self.childViewControllers containsObject:currentViewController]){
        [_mainView addSubview:currentViewController.view];
        [self addChildViewController:currentViewController];
    }
}

@end
