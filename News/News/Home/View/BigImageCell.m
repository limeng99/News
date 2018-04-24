//
//  BigImageCell.m
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "BigImageCell.h"

@interface BigImageCell()

@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation BigImageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BigImageCell";
    BigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[BigImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    _titLabel = [[UILabel alloc] init];
    _titLabel.numberOfLines = 0;
    if (SCREEN_WIDTH == 320) {
        _titLabel.font = [UIFont systemFontOfSize:15];
    }else{
        _titLabel.font = [UIFont systemFontOfSize:16];
    }
    [self.contentView addSubview:_titLabel];
    
    _imageV = [[UIImageView alloc] init];
    _imageV.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_imageV];
    
    _replyLabel = [[UILabel alloc] init];
    _replyLabel.textAlignment = NSTextAlignmentCenter;
    _replyLabel.font = [UIFont systemFontOfSize:10];
    _replyLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_replyLabel];
    
    _lineV = [[UIView alloc] init];
    _lineV.backgroundColor = UIColorHex(eeeeee);
    [self.contentView addSubview:_lineV];
    
    [_titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat imgW = (SCREEN_WIDTH -20);
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(_titLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(imgW);
        make.height.mas_equalTo(imgW*0.3);
    }];
}

-(void)setDataModel:(DataModel *)dataModel
{
    _dataModel = dataModel;
    
    [_imageV setImageWithURL:[NSURL URLWithString:self.dataModel.imgsrc]  placeholder:[UIImage imageNamed:@"placeholder"]];
    self.titLabel.text = self.dataModel.title;
    
    CGFloat count =  [self.dataModel.replyCount intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖",count];
    }
    self.replyLabel.text = displayCount;
    
    CGFloat w = [self.replyLabel.text widthForFont:[UIFont systemFontOfSize:10]];
    _replyLabel.frame = CGRectMake(SCREEN_WIDTH-w-20,(SCREEN_WIDTH -20)*0.3 + 55, w+10, 15);
    [self.replyLabel.layer setBorderWidth:1];
    [self.replyLabel.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.replyLabel.layer setCornerRadius:5];
    self.replyLabel.clipsToBounds = YES;
    
    _lineV.frame = CGRectMake(10, CGRectGetMaxY(_replyLabel.frame) + 10, SCREEN_WIDTH - 20, 1);    
}


@end
