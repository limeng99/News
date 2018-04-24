//
//  SCNavTabBar.h
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCNavTabBar;

@protocol SCNavTabBarDelegate<NSObject>

@optional
- (void)SCNavTabBar:(SCNavTabBar *)tabBar itemDidSelectedWithIndex:(NSInteger)index;
- (void)SCNavTabBar:(SCNavTabBar *)tabBar itemDidSelectedWithIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex;

@end

@interface SCNavTabBar : UIView

@property (nonatomic, weak) id<SCNavTabBarDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) NSMutableArray *items;

- (void)updateData;

@end
