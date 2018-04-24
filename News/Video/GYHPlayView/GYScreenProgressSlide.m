//
//  GYScreenProgressSlide.m
//  AFText
//
//  Created by 李萌萌 on 2018/4/19.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "GYScreenProgressSlide.h"

@interface GYScreenProgressSlide()

@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, weak) UILabel *slideTimeL;
@property (nonatomic, weak) UILabel *currentTimeL;
@property (nonatomic, weak) UILabel *totalTimeL;

@end

@implementation GYScreenProgressSlide

 - (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(100, 200, 250, 0.7);
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(15, 20, self.width - 30, 1)];
    progressView.trackTintColor = UIColorHex(C0C0C0);
    progressView.progressTintColor = UIColorHex(FF6100);
    [self addSubview:progressView];
    self.progressView = progressView;
    
    UILabel *slideTimeL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height*0.5 - 10, self.width, 20)];
    slideTimeL.font = [UIFont systemFontOfSize:20];
    slideTimeL.textColor = [UIColor whiteColor];
    slideTimeL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:slideTimeL];
    self.slideTimeL = slideTimeL;
    
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, slideTimeL.bottom + 15, self.width, 20)];
    [self addSubview:bottomV];
    
    UILabel *currentTimeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width * 0.5 - 5, 20)];
    currentTimeL.font = [UIFont systemFontOfSize:17];
    currentTimeL.textColor = UIColorHex(FFFAFA);
    currentTimeL.textAlignment = NSTextAlignmentRight;
    [bottomV addSubview:currentTimeL];
    self.currentTimeL = currentTimeL;
    
    UILabel *separatorL = [[UILabel alloc] initWithFrame:CGRectMake(currentTimeL.right, 0, 10 , 20)];
    separatorL.font = [UIFont systemFontOfSize:17];
    separatorL.textColor = UIColorHex(FFFAFA);
    separatorL.textAlignment = NSTextAlignmentCenter;
    separatorL.text = @"/";
    [bottomV addSubview:separatorL];
    
    UILabel *totalTimeL = [[UILabel alloc] initWithFrame:CGRectMake(self.width * 0.5 + 5, 0, self.width * 0.5 - 5, 20)];
    totalTimeL.font = [UIFont systemFontOfSize:17];
    totalTimeL.textColor = [UIColor whiteColor];
    totalTimeL.textAlignment = NSTextAlignmentLeft;
    [bottomV addSubview:totalTimeL];
    self.totalTimeL = totalTimeL;

}

- (void)setProgress:(CGFloat)progress
{
    if (progress > 1) {
        progress = 1.0;
    }
    if (_current < 0 ) {
        _current = 0;
    }
    if (_current == 0) {
        _slide = _slide < 0 ? 0 : _slide;
    }
    if (_current > _total) {
        _current = _total - 1;
    }
    NSString *slideTime = [NSString stringWithFormat:@"+ %@",[self convertTimeToString:_slide]];
    if (_slide <= 0) {
        slideTime = [NSString stringWithFormat:@"- %@",[self convertTimeToString:-_slide]];
    }
    self.progressView.progress = progress;
    self.slideTimeL.text = slideTime;
    self.currentTimeL.text = [self convertTimeToString:self.current];
    self.totalTimeL.text = [self convertTimeToString:self.total];
}

//转换时间成字符串
- (NSString *)convertTimeToString:(NSTimeInterval)time
{
    if (time <= 0) {
        return @"00:00";
    }
    int minute = time / 60;
    int second = (int)time % 60;
    NSString * timeStr;
    
    if (minute >= 100) {
        timeStr = [NSString stringWithFormat:@"%d:%02d", minute, second];
    }else {
        timeStr = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    return timeStr;
}



@end
