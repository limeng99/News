//
//  SCNavTabBar.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "SCNavTabBar.h"
#import "NSString+Extension.h"

@interface SCNavTabBar()

@property (nonatomic, strong) NSMutableArray *itemWidths;
@property (nonatomic, strong) UIScrollView *navgationTabBar;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SCNavTabBar

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray *)itemWidths
{
    if (_itemWidths == nil) {
        _itemWidths = [NSMutableArray array];
    }
    return _itemWidths;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig
{
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaStateHeight, SCREEN_WIDTH-40, 44)];
    _navgationTabBar.backgroundColor = [UIColor clearColor];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
}

- (void)updateData
{
    [self getButtonsWidthWithTitles:_itemTitles];
    if (self.itemWidths.count) {
        [self setItemButtons];
        _navgationTabBar.contentSize = CGSizeMake([self contentWidth], 0);
        [self setLineWithButtonWidth:[_itemWidths[0] floatValue]];
    }
}

- (void)setItemButtons
{
    CGFloat buttonX = 0;
    for (NSInteger index = 0; index < _itemTitles.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        CGSize size = CGSizeMake([_itemWidths[index] floatValue] + 15*2, 44);
        button.frame = CGRectMake(buttonX, 0, size.width, 44);
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.navgationTabBar addSubview:button];
        [self.items addObject:button];
        buttonX += button.frame.size.width;
    }
}

- (void)setLineWithButtonWidth:(CGFloat)width
{
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 45-3.0, width, 2.0)];
    _lineView.backgroundColor = _lineColor;
    [_navgationTabBar addSubview:_lineView];
    
    UIButton *btn = _items[0];
    [self itemPressed:btn];
}

- (void)itemPressed:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SCNavTabBar:itemDidSelectedWithIndex:currentIndex:)]) {
        [self.delegate SCNavTabBar:self itemDidSelectedWithIndex:[_items indexOfObject:button] currentIndex:_currentIndex];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    UIButton *btn = (UIButton *)_items[currentIndex];
    
    CGFloat flag = SCREEN_WIDTH - 40;
    if (btn.frame.origin.x + btn.frame.size.width >= flag) {
        CGFloat offsetX = btn.frame.origin.x + btn.frame.size.width - flag;
        if (currentIndex != _items.count -1 ) {
            offsetX = offsetX + btn.frame.size.width;
        }
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    } else {
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    [UIView animateWithDuration:0.1f animations:^{
        _lineView.frame = CGRectMake(btn.frame.origin.x + 15, _lineView.frame.origin.y, [_itemWidths[currentIndex] floatValue], _lineView.frame.size.height);
    }];
}

- (CGFloat)contentWidth
{
    UIButton *lastBtn = self.items.lastObject;
    return lastBtn.frame.size.width + lastBtn.frame.origin.x;
}

- (void)getButtonsWidthWithTitles:(NSArray *)titles
{
    for (NSString *title in titles) {
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, _navgationTabBar.frame.size.height)];
        [self.itemWidths addObject:@(size.width)];
    }
}



@end
