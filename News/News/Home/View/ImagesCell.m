//
//  ImagesCell.m
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "ImagesCell.h"

@interface ImagesCell()

@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UIImageView *imageV1;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UIImageView *imageV3;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation ImagesCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ImagesCell";
    ImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[ImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    _imageV1 = [[UIImageView alloc] init];
    _imageV1.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_imageV1];
    
    _imageV2 = [[UIImageView alloc] init];
    _imageV2.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_imageV2];

    _imageV3 = [[UIImageView alloc] init];
    _imageV3.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_imageV3];

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
    
    CGFloat imgW = (SCREEN_WIDTH -40)/3;
    [_imageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(_titLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(imgW);
        make.height.mas_equalTo(imgW*0.7);
    }];
    [_imageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(_imageV1);
        make.left.equalTo(_imageV1.mas_right).offset(10);
    }];
    [_imageV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(_imageV1);
        make.left.equalTo(_imageV2.mas_right).offset(10);
    }];
}

-(void)setDataModel:(DataModel *)dataModel
{
    _dataModel = dataModel;
        
    [_imageV1 setImageWithURL:[NSURL URLWithString:self.dataModel.imgsrc]  placeholder:[UIImage imageNamed:@"placeholder"]];
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
    _replyLabel.frame = CGRectMake(SCREEN_WIDTH-w-20, (SCREEN_WIDTH -40)/3*0.7+42, w+10, 15);
    [self.replyLabel.layer setBorderWidth:1];
    [self.replyLabel.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.replyLabel.layer setCornerRadius:5];
    self.replyLabel.clipsToBounds = YES;

    _lineV.frame = CGRectMake(10, CGRectGetMaxY(_replyLabel.frame) + 10, SCREEN_WIDTH - 20, 1);
    if (self.dataModel.imgextra.count == 2) {
        [_imageV2 setImageWithURL:[NSURL URLWithString:self.dataModel.imgextra[0][@"imgsrc"]]  placeholder:[UIImage imageNamed:@"placeholder"]];
        [_imageV3 setImageWithURL:[NSURL URLWithString:self.dataModel.imgextra[1][@"imgsrc"]]  placeholder:[UIImage imageNamed:@"placeholder"]];
    }
    
}

@end
