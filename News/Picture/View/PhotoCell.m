//
//  PhotoCell.m
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell()

@property (nonatomic, strong) UIImageView *photoV;
@property (nonatomic, strong) UILabel *photoL;

@end

@implementation PhotoCell


+ (instancetype)itemCellWithCollection:(UICollectionView *)collectionV indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"PhotoCell";
    PhotoCell *cell = [collectionV dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
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
    _photoV = [[UIImageView alloc] init];
    _photoV.userInteractionEnabled = YES;
    [_photoV setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:_photoV];
    
    _photoL = [[UILabel alloc] init];
    _photoL.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    _photoL.font = [UIFont systemFontOfSize:17];
    _photoL.textColor = [UIColor blackColor];
    _photoL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_photoL];
    
    [_photoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.top.equalTo(self.contentView);
    }];
    [_photoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
}

- (void)setPhoto:(Photo *)photo
{
    [_photoV setImageWithURL:[NSURL URLWithString:photo.small_url] placeholder:nil];
    _photoL.text = photo.title;
}


@end
