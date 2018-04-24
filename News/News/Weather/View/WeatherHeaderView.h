//
//  WeatherHeaderView.h
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherHeaderView : UIView

@property (nonatomic, copy) void(^backBlock)(void);
@property (nonatomic, copy) void(^localBlock)(void);
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
