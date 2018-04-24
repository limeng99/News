//
//  PullDownView.m
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "PullDownView.h"
#import "PullDownCell.h"

@implementation PullDownItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon
{
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = icon;
    }
    return self;
}

+ (PullDownItem *)itemWithTitle:(NSString *)title icon:(UIImage *)icon
{
    return [[self alloc] initWithTitle:title icon:icon];
}


@end

@interface PullDownView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PullDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self prepareUI];
    }
    return self;
}


- (void)prepareUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 75);
    layout.minimumInteritemSpacing = (SCREEN_WIDTH - 200)/5;
    layout.minimumLineSpacing = 20.f;
    layout.sectionInset = UIEdgeInsetsMake(20, (SCREEN_WIDTH - 250)/5.f, 0, (SCREEN_WIDTH - 250)/5.f);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
    _collectionView.backgroundColor = RGBA(0, 0, 0, 0.8);
    _collectionView.userInteractionEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[PullDownCell class] forCellWithReuseIdentifier:@"PullDownCell"];
}

- (void)showCompletion:(completion)block
{
    if (self.superview)
        return;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        _collectionView.height = 300;
    } completion:^(BOOL finished) {
        if (block) {
            block(finished);
        }
    }];
}

- (void)hiddenCompletion:(completion)block
{
    [UIView animateWithDuration:0.2 animations:^{
        _collectionView.height = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (block) {
            block(finished);
        }
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PullDownCell * cell = [PullDownCell itemCellWithCollection:collectionView indexPath:indexPath];
    cell.item = _dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PullDownItem *item = _dataArray[indexPath.row];
    if (self.selectedBlock) {
        _isShow = NO;
        self.selectedBlock(item.title);
    }
    [self hiddenCompletion:nil];
}

@end
