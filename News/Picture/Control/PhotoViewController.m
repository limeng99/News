//
//  PhotoViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIBarButtonItem+gyh.h"
#import "PullDownView.h"
#import "HMWaterflowLayout.h"
#import "GYHHeadeRefreshController.h"
#import "Photo.h"
#import "PhotoCell.h"
#import "PhotoShowViewController.h"

@interface PhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, HMWaterflowLayoutDelegate>

@property (nonatomic, copy) NSString *degreeName;
@property (nonatomic, strong) PullDownView *pullView;
@property (nonatomic, strong) NSArray *classArray;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *tag1;
@property (nonatomic, copy) NSString *tag2;

@end

@implementation PhotoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _degreeName = @"美女";
    self.tag1 = @"美女";
    self.tag2 = @"性感";
    
    [self setNavArrow];
    [self setCollection];
    [self requestData];
}

#pragma mark - PullDownView
-(NSArray *)classArray
{
    if (!_classArray) {
        _classArray = @[
                        [PullDownItem itemWithTitle:@"美女" icon:[UIImage imageNamed:@"meinvchannel"]],
                        [PullDownItem itemWithTitle:@"明星" icon:[UIImage imageNamed:@"mingxing"]],
                        [PullDownItem itemWithTitle:@"汽车" icon:[UIImage imageNamed:@"qiche"]],
                        [PullDownItem itemWithTitle:@"宠物" icon:[UIImage imageNamed:@"chongwu"]],
                        [PullDownItem itemWithTitle:@"动漫" icon:[UIImage imageNamed:@"dongman"]],
                        [PullDownItem itemWithTitle:@"设计" icon:[UIImage imageNamed:@"sheji"]],
                        [PullDownItem itemWithTitle:@"家居" icon:[UIImage imageNamed:@"jiaju"]],
                        [PullDownItem itemWithTitle:@"婚嫁" icon:[UIImage imageNamed:@"hunjia"]],
                        [PullDownItem itemWithTitle:@"摄影" icon:[UIImage imageNamed:@"sheying"]],
                        [PullDownItem itemWithTitle:@"美食" icon:[UIImage imageNamed:@"meishi"]]
                        ];
    }
    return _classArray;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    __weak typeof(self) weakSelf = self;
    if (self.pullView.isShow) {
        [self.pullView hiddenCompletion:^(BOOL finished) {
            _pullView.isShow = NO;
            [weakSelf setNavArrow];
        }];
    }
}

- (PullDownView *)pullView
{
    if (_pullView == nil) {
        __weak typeof(self) weakSelf = self;
        _pullView = [[PullDownView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _pullView.dataArray = [NSMutableArray arrayWithArray:self.classArray];
        _pullView.selectedBlock = ^(NSString *title){
            weakSelf.tag1 = title;
            weakSelf.tag2 = @"全部";
            [weakSelf.collectionView.mj_header beginRefreshing];
            weakSelf.degreeName = title;
            [weakSelf setNavArrow];
        };
    }
    return _pullView;
}

- (void)openMenu
{
    __weak typeof(self) weakSelf = self;
    if (self.pullView.isShow) {
        [self.pullView hiddenCompletion:^(BOOL finished) {
            weakSelf.pullView.isShow = NO;
            [weakSelf setNavArrow];
        }];
    } else {
        [self.pullView showCompletion:^(BOOL finished) {
            weakSelf.pullView.isShow = YES;
            [weakSelf setNavArrow];
        }];
    }
}

- (void)setNavArrow
{
    NSString *imageName = @"arrow_down";
    if (self.pullView.isShow) {
        imageName = @"arrow_up";
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem
                                              navigationBarRightButtonItemWithTitleAndImage:[UIImage imageNamed:imageName]
                                              Title:self.degreeName
                                              Target:self
                                              Selector:@selector(openMenu)
                                              titleColor:nil];
}

#pragma mark - setCollection
- (void)setCollection
{
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
    layout.numberOfColumns = 2;
    layout.cellDistance = 5;
    layout.topAndBottomDustance = 5;
    layout.delegate = self;
 
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColorHex(f5f8f9);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshStateHeader *header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
        [weakSelf.dataArray removeAllObjects];
        weakSelf.page = 0;
        [weakSelf requestData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    _collectionView.mj_header = header;
    [_collectionView.mj_header beginRefreshing];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 60;
        [weakSelf requestData];
    }];

}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=%@",self.tag1,self.tag2];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"pn"] = [NSString stringWithFormat:@"%d",self.page];
    params[@"rn"] = @60;
    [[HttpRequestHelper sharedHttpRequest] getRequestUrl:url setParams:params didFinish:^(id json, NSError *error) {
        if (error == nil) {
            for (NSDictionary *dic in json[@"imgs"]) {
                Photo *model = [Photo modelWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
            [_collectionView reloadData];
        }
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [PhotoCell itemCellWithCollection:collectionView indexPath:indexPath];
    cell.photo = _dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoShowViewController *photoShow = [[PhotoShowViewController alloc]init];
//    photoShow.currentIndex = (int)indexPath.row;
    photoShow.photoArray = self.dataArray;
    [self.navigationController pushViewController:photoShow animated:YES];
}

#pragma mark -HMWaterflowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HMWaterflowLayout *)layout heightOfItemIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    Photo *photo = _dataArray[indexPath.row];
    return (photo.small_height / photo.small_width) * itemWidth;
}


@end
