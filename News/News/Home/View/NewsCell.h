//
//  NewsCell.h
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataModel;

@interface NewsCell : UITableViewCell

@property (nonatomic, strong) DataModel *dataModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (NSString *)idForRow:(DataModel *)NewsModel;
+ (CGFloat)heightForRow:(DataModel *)NewsModel;

@end
