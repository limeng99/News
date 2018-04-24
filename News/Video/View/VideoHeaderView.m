//
//  VideoHeaderView.m
//  News
//
//  Created by 李萌萌 on 2018/4/14.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "VideoHeaderView.h"

@implementation CustomButton

+ (instancetype)buttonWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title
{
    CustomButton *btn = [[self alloc] initWithFrame:frame];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(10, -btn.imageView.frame.size.width, -btn.imageView.frame.size.height, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
    return btn;
}
@end

@implementation VideoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    NSArray *titles = @[@"奇葩",@"萌物",@"美女",@"精品"];
    NSArray *images = @[[UIImage imageNamed:@"qipa"],
                        [UIImage imageNamed:@"mengchong"],
                        [UIImage imageNamed:@"meinv"],
                        [UIImage imageNamed:@"jingpin"]];
    for (int index = 0; index < 4 ; index++) {
        CGFloat btnW = self.width*0.25 - 0.5;
        CGFloat btnH = self.width*0.25 - 5;
        CGFloat btnX = (btnW + 0.5)* index;
        CGFloat btnY = 0;
        CGRect btnRect = CGRectMake(btnX, btnY, btnW, btnH);
        CustomButton *btn = [CustomButton buttonWithFrame:btnRect image:images[index] title:titles[index]];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = index + 10;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    for (int index = 0; index < 3; index++) {
        CGFloat lineW = 1;
        CGFloat lineH = self.width*0.25 - 30;
        CGFloat lineX = self.width*0.25 *  (index + 1);
        CGFloat lineY = 15;
        CGRect lineRect = CGRectMake(lineX, lineY, lineW, lineH);
        UIView *lineView = [[UIView alloc] initWithFrame:lineRect];
        lineView.backgroundColor =RGB(244, 244, 244);
        [self addSubview:lineView];
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 5, self.width, 5)];
    bottomView.backgroundColor =RGB(244, 244, 244);
    [self addSubview:bottomView];
}

- (void)btnClick:(UIButton *)btn
{
    if (self.selectedBlock) {
        self.selectedBlock(btn.tag - 10, btn.titleLabel.text);
    }
}

@end
