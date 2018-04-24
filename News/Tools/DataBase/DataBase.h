//
//  DataBase.h
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataModel;
@interface DataBase : NSObject

// db配置
+ (void)dataBaseConfig;

// 获取所有省市
+ (NSArray *)getStates;

// 收藏
+ (void)newsCollect:(DataModel *)newsData;

// 收藏查询
+ (BOOL)queryCollect:(DataModel *)newsData;

// 获取收藏列表
+ (NSArray *)getCollects;

// 删除收藏
+ (void)deleteCollect:(DataModel *)newsData;

@end
