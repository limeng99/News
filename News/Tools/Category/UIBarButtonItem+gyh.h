//
//  UIBarButtonItem+gyh.h
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (gyh)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

+ (UIBarButtonItem*)navigationBarRightButtonItemWithTitleAndImage:(UIImage *)image Title:(NSString *)title Target:(id)target Selector:(SEL)sel titleColor:(UIColor *)titleColor;

@end
