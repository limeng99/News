//
//  GYScreenProgressSlide.h
//  AFText
//
//  Created by 李萌萌 on 2018/4/19.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYScreenProgressSlide : UIView

@property (nonatomic, assign) NSTimeInterval current;
@property (nonatomic, assign) NSTimeInterval total;
@property (nonatomic, assign) NSTimeInterval slide;
@property (nonatomic, assign) CGFloat progress;

@end
