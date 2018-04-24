//
//  PullDownCell.m
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "PullDownCell.h"
#import "PullDownView.h"

@interface PullDownCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *iconLabel;

@end

@implementation PullDownCell

+ (instancetype)itemCellWithCollection:(UICollectionView *)collectionV indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"PullDownCell";
    PullDownCell *cell = [collectionV dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    _iconView = [[UIImageView alloc] init];
    _iconView.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconView];
    
    _iconLabel = [[UILabel alloc] init];
    _iconLabel.font = [UIFont systemFontOfSize:15];
    _iconLabel.textColor = [UIColor whiteColor];
    _iconLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_iconLabel];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    [_iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
}

- (void)setItem:(PullDownItem *)item
{
    _item = item;
    _iconView.image = item.icon;
    _iconLabel.text = item.title;
}

@end
