//
//  MyHeaderView.h
//  News
//
//  Created by 李萌萌 on 2018/4/15.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeaderView : UIView

@property (nonatomic , weak) UIImageView *photoimageV; 
@property (nonatomic , weak) UILabel *nameL;
@property (nonatomic , copy) void(^loginBlock)(void);

@end
