//
//  LocalHeaderView.m
//  News
//
//  Created by 李萌萌 on 2018/4/18.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "LocalHeaderView.h"
#import "State.h"

@interface LocalHeaderView()

@property (nonatomic, weak) UIButton *namebtn;

@end

@implementation LocalHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"header";
    LocalHeaderView *header = [tableview dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!header) {
        header = [[LocalHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton *namebtn = [[UIButton alloc] init];
        [namebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        namebtn.titleLabel.font = [UIFont systemFontOfSize:15];
        namebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        namebtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [self.contentView addSubview:namebtn];
        self.namebtn = namebtn;
    }
    return self;
}

- (void)setState:(State *)state
{
    _state = state;
    [self.namebtn setTitle:state.stateName forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.namebtn.frame = self.bounds;
}

@end
