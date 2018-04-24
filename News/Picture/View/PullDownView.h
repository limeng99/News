//
//  PullDownView.h
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownItem: NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIImage *icon;

+ (PullDownItem *)itemWithTitle:(NSString *)title icon:(UIImage *)icon;

@end

typedef void(^completion)(BOOL finished);
@interface PullDownView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign, getter=isShow) bool isShow;
@property (nonatomic, copy) void(^selectedBlock)(NSString *title);

- (void)showCompletion:(completion)block;
- (void)hiddenCompletion:(completion)block;


@end
