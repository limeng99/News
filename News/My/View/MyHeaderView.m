//
//  MyHeaderView.m
//  News
//
//  Created by 李萌萌 on 2018/4/15.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "MyHeaderView.h"

@implementation MyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(186, 71, 58);
        
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(self.width/2-40, self.height/2-40, 80, 80);
        imageV.image = [UIImage imageNamed:@"comment_profile_default"];
        [self addSubview:imageV];
        [imageV.layer setCornerRadius:40];
        imageV.clipsToBounds = YES;
        imageV.userInteractionEnabled = YES;
        self.photoimageV = imageV;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+10, SCREEN_WIDTH, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"立即登录";
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        label.userInteractionEnabled = YES;
        self.nameL = label;
        
        UIButton *cover = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height/2-40, 80, 110)];
        [cover addTarget:self action:@selector(countLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
        
    }
    return self;
}

#pragma mark - 登录
- (void)countLogin
{
    if ([self.nameL.text isEqualToString:@"立即登录"]){
        if (self.loginBlock) {
            self.loginBlock();
        }
    }else{
        
    }
}



@end
