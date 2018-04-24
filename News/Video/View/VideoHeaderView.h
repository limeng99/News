//
//  VideoHeaderView.h
//  News
//
//  Created by 李萌萌 on 2018/4/14.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

+ (instancetype)buttonWithFrame:(CGRect)frame image:(NSString *)image title:(NSString *)title;

@end


@interface VideoHeaderView : UIView

@property (nonatomic, copy) void(^selectedBlock)(NSInteger index, NSString *title);

@end
