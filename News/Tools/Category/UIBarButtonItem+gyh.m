//
//  UIBarButtonItem+gyh.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "UIBarButtonItem+gyh.h"

@implementation UIBarButtonItem (gyh)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, CGSizeMake(54, 44)};
    DLog(@"%@",NSStringFromCGRect(button.frame));
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)ItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointZero,40,30};
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

///显示文字和图片样式，左文字，右图片
+ (UIBarButtonItem*)navigationBarRightButtonItemWithTitleAndImage:(UIImage *)image Title:(NSString *)title Target:(id)target Selector:(SEL)sel titleColor:(UIColor *)titleColor
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.tag = 200;
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }else {
        [btn setTitleColor:UIColorHex(333333) forState:UIControlStateNormal];
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    
    CGFloat width = [title widthForFont:[UIFont systemFontOfSize:16]];
    btn.frame = CGRectMake(0, 0, width + 20, 44);
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.image.size.width - 8, 0, btn.imageView.image.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, width, 0, -width - 8)];
    
    //iOS7下面导航按钮会默认有10px间距
    btn.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

@end
