//
//  LocalHeaderView.h
//  News
//
//  Created by 李萌萌 on 2018/4/18.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class State;
@interface LocalHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) State *state;
+ (instancetype)headerWithTableView:(UITableView *)tableview;

@end
