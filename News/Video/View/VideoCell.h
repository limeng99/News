//
//  VideoCell.h
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoDataFrame;
@interface VideoCell : UITableViewCell

@property (nonatomic, strong) VideoDataFrame *videoFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
