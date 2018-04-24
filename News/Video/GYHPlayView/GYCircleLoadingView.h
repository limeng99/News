//
//  GYHCircleLoadingView.h
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYCircleLoadingView : UIView

// 进度
@property (nonatomic, assign) CGFloat progress;

// 是否显示进度
@property (nonatomic, assign) BOOL isShowProgress;

// 开启动画
- (void)startAnimating;

// 关闭动画
- (void)stopAnimating;

// 初始化，有默认值
- (instancetype)initWithViewFrame:(CGRect)frame;

// 自定义初始化
- (instancetype)initWithViewFrame:(CGRect)frame tintColor:(UIColor *)tintColor size:(CGFloat)size lineWidth:(CGFloat)lineWidth;


@end
