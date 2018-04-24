//
//  VideoCell.m
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "VideoCell.h"
#import "VideoDataFrame.h"
#import "VideoData.h"

@interface VideoCell()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *titleL;
@property (nonatomic, weak) UILabel *lengthL;
@property (nonatomic, weak) UIImageView *playImage;
@property (nonatomic , weak) UIImageView *playCoverImage;
@property (nonatomic, weak) UILabel *sourceL;
@property (nonatomic, weak) UILabel *ptimeL;
@property (nonatomic, weak) UIView *lineV;

@end

@implementation VideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"VideoCell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    //图片
    UIImageView *imageview = [[UIImageView alloc]init];
    [self.contentView addSubview:imageview];
    self.imageV = imageview;
    
    //题目背景
    UIImageView *imgBgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    imgBgTop.image = [UIImage imageNamed:@"top_shadow.png"];
    [self.contentView addSubview:imgBgTop];
    
    //题目
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = UIColorHex(ffffff);
    [self.contentView addSubview:titleLabel];
    self.titleL = titleLabel;
    
    UIImageView *playcoverImage = [[UIImageView alloc]init];
    [self.contentView addSubview:playcoverImage];
    self.playCoverImage = playcoverImage;
    
    //时长
    UILabel *lengthLabel = [[UILabel alloc]init];
    lengthLabel.textColor =UIColorHex(ffffff);
    lengthLabel.backgroundColor = RGBA(1, 1, 1, 0.3);
    lengthLabel.textAlignment = NSTextAlignmentCenter;
    lengthLabel.layer.cornerRadius = 10;
    lengthLabel.layer.masksToBounds = YES;
    lengthLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:lengthLabel];
    self.lengthL = lengthLabel;
    
    //来源图标
    UIImageView *playImage = [[UIImageView alloc] init];
    playImage.layer.cornerRadius = 12;
    playImage.layer.masksToBounds = YES;
    [self.contentView addSubview:playImage];
    self.playImage = playImage;
    
    //来源文字
    UILabel *lbSource = [[UILabel alloc] init];
    lbSource.font = [UIFont systemFontOfSize:13];
    lbSource.textColor = UIColorHex(333333);
    [self.contentView addSubview:lbSource];
    self.sourceL = lbSource;
    
    //时间
    UILabel *ptimeLabel = [[UILabel alloc]init];
    ptimeLabel.textColor = UIColorHex(797979);
    ptimeLabel.font = [UIFont systemFontOfSize:13];
    ptimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:ptimeLabel];
    self.ptimeL = ptimeLabel;
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = RGBA(239, 239, 244, 1);
    [self.contentView addSubview:lineV];
    self.lineV = lineV;
}

- (void)setVideoFrame:(VideoDataFrame *)videoFrame
{
    _videoFrame = videoFrame;
    VideoData *videoData = _videoFrame.videoData;
    
    [_imageV setImageWithURL:[NSURL URLWithString:videoData.cover] placeholder:[UIImage imageNamed:@"sc_video_play_fs_loading_bg.png"]];
    _imageV.frame = _videoFrame.coverF;
    
    //题目
    NSString *str = [videoData.title stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    self.titleL.text = str;
    self.titleL.frame = _videoFrame.titleF;
    
    self.playCoverImage.image = [UIImage imageNamed:@"play_btn"];
    self.playCoverImage.frame = _videoFrame.playF;
    
    self.lengthL.text = [self convertTime:videoData.length];
    self.lengthL.frame = _videoFrame.lengthF;
    
    [self.playImage setImageWithURL:[NSURL URLWithString:videoData.topicImg] placeholder:nil];
    self.playImage.frame = _videoFrame.playImageF;
    
    self.sourceL.text = videoData.topicName;
    self.sourceL.frame = _videoFrame.playCountF;
    
    //时间
    self.ptimeL.text = videoData.ptime;
    self.ptimeL.frame = _videoFrame.ptimeF;
    
    self.lineV.frame = _videoFrame.lineVF;

}

//时间转换
- (NSString *)convertTime:(CGFloat)second{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [fmt setDateFormat:@"HH:mm:ss"];
    } else {
        [fmt setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [fmt stringFromDate:d];
    return showtimeNew;
}


@end
