//
//  GYPlayer.h
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class GYPlayer;
@protocol GYPlayerDelegate <NSObject>

@optional
// 开始播放
- (void)playerView:(GYPlayer *)playView didPlayStart:(AVPlayer *)player;
// 播放中
- (void)playerView:(GYPlayer *)playView didPlaying:(AVPlayer *)play playTime:(NSTimeInterval)playTime;
// 播放结束
- (void)playerView:(GYPlayer *)playView didPlayEnd:(AVPlayer *)player;
// 全屏缩为小屏
- (void)playerView:(GYPlayer *)playView didExitFullScreen:(AVPlayer *)player;
// 删除播放器
- (void)playerView:(GYPlayer *)playView didRemovePlay:(AVPlayer *)player;

@end

@interface GYPlayer : UIView

/** 标题 */
@property (nonatomic , strong) NSString *title;
/** video的url */
@property (nonatomic , strong) NSString *mp4_url;
/** cell在tableview里的y坐标 */
@property (nonatomic, assign)  CGFloat currentOriginY;
/** delegate */
@property (nonatomic, weak) id<GYPlayerDelegate> delegate;

/** 播放 */
- (void)play;

/** 暂停 */
- (void)pause;

/** cell超出屏幕 */
- (void)beyondScreen;

/** cell 返回屏幕 */
- (void)backScreen:(UIView *)view;

/** 大屏自动播放调用 */
- (void)autoFullScreenPlay;

/** 移除 */
- (void)removePlayer;

@end
