//
//  NewsCell.m
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "NewsCell.h"
#import "DataModel.h"

@interface NewsCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UILabel *resorceLable;

@end

@implementation NewsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    _iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:_iconView];
    
    _titLabel = [[UILabel alloc] init];
    _titLabel.numberOfLines = 0;
    if (SCREEN_WIDTH == 320) {
        _titLabel.font = [UIFont systemFontOfSize:15];
    }else{
        _titLabel.font = [UIFont systemFontOfSize:16];
    }
    [self.contentView addSubview:_titLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.numberOfLines = 0;
    _subLabel.font = [UIFont systemFontOfSize:14];
    _subLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_subLabel];
    
    _replyLabel = [[UILabel alloc]init];
    _replyLabel.textAlignment = NSTextAlignmentCenter;
    _replyLabel.font = [UIFont systemFontOfSize:10];
    _replyLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_replyLabel];
    
    _resorceLable = [[UILabel alloc]init];
    _resorceLable.font = [UIFont systemFontOfSize:10];
    _resorceLable.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_resorceLable];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 79, SCREEN_WIDTH - 20, 1)];
    line.backgroundColor = UIColorHex(eeeeee);
    [self.contentView addSubview:line];

    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(80, 60));
    }];
    [_titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_titLabel);
        make.top.equalTo(_titLabel.mas_bottom);
    }];
    [_resorceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView.mas_bottom).offset(-10);
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
    }];
}

- (void)setDataModel:(DataModel *)dataModel
{
    _dataModel = dataModel;
    
    [_iconView setImageWithURL:[NSURL URLWithString:self.dataModel.imgsrc] placeholder:[UIImage imageNamed:@"placeholder"]];
    self.titLabel.text = self.dataModel.title;
    self.resorceLable.text = self.dataModel.source;
    
    // 如果回复太多就改成几点几万
    CGFloat count =  [self.dataModel.replyCount intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖",count];
    }
    self.replyLabel.text = displayCount;
    
    CGFloat w = [self.replyLabel.text widthForFont:[UIFont systemFontOfSize:10]];
    _replyLabel.frame = CGRectMake(SCREEN_WIDTH-w-20, 60, w+10, 15);
    [self.replyLabel.layer setBorderWidth:1];
    [self.replyLabel.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.replyLabel.layer setCornerRadius:5];
    self.replyLabel.clipsToBounds = YES;
}

#pragma mark - 返回可重用ID
+ (NSString *)idForRow:(DataModel *)NewsModel
{
    if (NewsModel.hasHead && NewsModel.photosetID) {
        return @"TopImageCell";
    }else if (NewsModel.hasHead){
        return @"TopTxtCell";
    }else if (NewsModel.imgType){
        return @"BigImageCell";
    }else if (NewsModel.imgextra){
        return @"ImagesCell";
    }else{
        return @"NewsCell";
    }
}

+ (CGFloat)heightForRow:(DataModel *)NewsModel
{
    if (NewsModel.hasHead && NewsModel.photosetID){
        return 0;
    }else if(NewsModel.hasHead) {
        return 0;
    }else if(NewsModel.imgType) {
        if (SCREEN_WIDTH == 320) {
            return 180;
        }else{
            return 196;
        }
    }else if (NewsModel.imgextra){
        if (SCREEN_WIDTH == 320) {
            return 135;
        }else{
            return 150;
        }
    }else{
        return 80;
    }
}


@end
