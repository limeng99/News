//
//  VideoDataFrame.m
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#define padding 10

#import "VideoDataFrame.h"

@implementation VideoDataFrame

-  (void)setVideoData:(VideoData *)videoData
{
    _videoData = videoData;
    
    //图片
    CGFloat coverX = 0;
    CGFloat coverY = 0;
    CGFloat coverW = SCREEN_WIDTH;
    CGFloat coverH = coverW * 0.56;
    _coverF = CGRectMake(coverX, coverY, coverW, coverH);
    
    //题目
    CGFloat titleX = padding;
    CGFloat titleY = padding;
    CGFloat titleW = SCREEN_WIDTH - 2*padding;
    CGFloat titleH = 40;
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);
    
    //播放暂停按钮
    CGFloat playW = 50;
    CGFloat playH = 50;
    CGFloat playX = coverW/2 - 25;
    CGFloat playY = coverH/2 - 25;
    _playF = CGRectMake(playX, playY, playW, playH);
    
    //时长
    CGFloat lengthW = 40;
    CGFloat lengthH = 20;
    CGFloat lengthX = SCREEN_WIDTH - lengthW - 5;
    CGFloat lengthY = CGRectGetMaxY(_coverF) - lengthH - 5;
    _lengthF = CGRectMake(lengthX, lengthY, lengthW, lengthH);
    
    //播放来源图片
    CGFloat playImageX = padding;
    CGFloat playImageY = CGRectGetMaxY(_coverF) + 8;
    CGFloat playImageW = 24;
    CGFloat playImageH = 24;
    _playImageF = CGRectMake(playImageX, playImageY, playImageW, playImageH);
    
    //播放来源文字
    CGFloat playcountX = CGRectGetMaxX(_playImageF) + 5;
    CGFloat playcountY = CGRectGetMaxY(_coverF);
    CGFloat playcountW = 100;
    CGFloat playcountH = 40;
    _playCountF = CGRectMake(playcountX, playcountY, playcountW, playcountH);
    
    //时间
    CGFloat ptimeW = 45;
    CGFloat ptimeH = 40;
    CGFloat ptimeX = SCREEN_WIDTH - ptimeW - 5;
    CGFloat ptimeY = CGRectGetMaxY(_coverF);
    _ptimeF = CGRectMake(ptimeX, ptimeY, ptimeW, ptimeH);
    
    //灰块
    CGFloat lineW = SCREEN_WIDTH;
    CGFloat lineH = 5;
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(_ptimeF);
    _lineVF = CGRectMake(lineX, lineY, lineW, lineH);
    
    _cellH = CGRectGetMaxY(_lineVF);
    
}

@end
