//
//  GYProgressSlider.h
//  News
//
//  Created by 李萌萌 on 2018/4/13.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYSliderDirection) {
    
    RHSliderDirectionHorizonal = 0,
    RHSliderDirectionVertical  = 1
};
@interface GYProgressSlider : UIControl

// 最小值
@property (nonatomic, assign) CGFloat minValue;
// 最大值
@property (nonatomic, assign) CGFloat maxValue;
// 滑动值
@property (nonatomic, assign) CGFloat value;
// 滑动百分比
@property (nonatomic, assign) CGFloat sliderPercent;
// 缓冲的百分比
@property (nonatomic, assign) CGFloat progressPercent;
// 是否正在滑动  如果在滑动的是偶外面监听的回调不应该设置sliderPercent progressPercent 避免绘制混乱
@property (nonatomic, assign) BOOL isSliding;
// 方向
@property (nonatomic, assign) GYSliderDirection direction;

- (instancetype)initWithFrame:(CGRect)frame direction:(GYSliderDirection)direction;

@end

