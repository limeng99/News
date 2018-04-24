//
//  GYPlayer.m
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "GYPlayer.h"
#import "GYCircleLoadingView.h"
#import "GYProgressSlider.h"

#import "GYScreenProgressSlide.h"

static BOOL _prePlayerIsFullScreen = NO;

@interface GYPlayer()
{
    // 快进/后退相关
    CGPoint _beginPoint;
    NSTimeInterval _current;
    NSTimeInterval _total;
    BOOL _isMove;
}

@property (strong, nonatomic)AVPlayer *player; //播放器
@property (strong, nonatomic)AVPlayerItem *playerItem; //播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer; //播放界面（layer）

@property (nonatomic, strong) GYCircleLoadingView *circleLoadingView;

@property (nonatomic, strong) UIView *maskView;     //整个view
@property (nonatomic, strong) UILabel *titleL;        //视频标题
@property (nonatomic, strong) UIImageView *topSideBar;       //视频标题背景
@property (nonatomic, strong) UIButton *playClose;
@property (nonatomic, strong) UIButton *fullScreenBack;

@property (nonatomic, strong) UIImageView *toolView;    // 底部背景栏
@property (nonatomic, strong) UIButton *pausePlay;  // 中部播放暂停键
@property (nonatomic, strong) UILabel *currentTimeLabel; // 播放时间
@property (nonatomic, strong) GYProgressSlider *slider; // 播放进度条
@property (nonatomic, strong) UILabel *totleTimeLabel; // 播放总时间
@property (nonatomic, strong) UIButton *playSwitch; //播放暂停
@property (nonatomic, strong) UIButton *fullScreen;  //全屏按钮

@property (nonatomic, assign) BOOL isFirstPlay; // 第一次点击
@property (nonatomic, assign) BOOL maskIsShow; // maskView是否显示
@property (nonatomic, assign) BOOL isBeyondScreen; // 是否超出屏幕
@property (nonatomic, assign) BOOL isFullScreen; // 是否全屏

@property (nonatomic, strong) CADisplayLink * link;
@property (nonatomic, assign) NSTimeInterval lastTime;

@property (nonatomic, strong) NSTimer * toolViewShowTimer;
@property (nonatomic, assign) NSTimeInterval toolViewShowTime;

@property (nonatomic, strong) GYScreenProgressSlide *screenSlider; // 快进/后退

@end

@implementation GYPlayer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)play
{
    if (self.mp4_url == nil) {return; }
    self.link.paused = NO;
    if (self.isFirstPlay) {
        [self addMaskViewTimer];
    } else {
        [self hideMaskView];
    }
    [self.player play];
}

- (void)pause
{
    self.link.paused = YES;
    [self pauseMaskStatue];
    [self.player pause];
}

- (void)beyondScreen
{
    if (self.isBeyondScreen) {return;}
    self.isBeyondScreen = YES;
    self.frame = CGRectMake(SCREEN_WIDTH - self.width*0.5, SCREEN_HEIGHT - 49 - self.height*0.5, self.width*0.5, self.height*0.5);
    self.playerLayer.frame = self.bounds;
    self.maskView.frame = CGRectMake(0, 0, self.width, self.height);
    self.maskView.hidden = YES;
    self.playClose.hidden = NO;
    [self addMaskSubViewFrame];
    [AppWindow addSubview:self];
    DLog(@"------------beyondScreen ");
}

- (void)backScreen:(UIView *)view
{
    if (!self.isBeyondScreen) { return;}
    self.isBeyondScreen = NO;
    self.maskView.hidden = NO;
    self.playClose.hidden = YES;
    self.frame = CGRectMake(0, self.currentOriginY, SCREEN_WIDTH, SCREEN_WIDTH * 0.56);
    self.playerLayer.frame = self.bounds;
    self.maskView.frame = CGRectMake(0, 0, self.width, self.height);
    [self addMaskSubViewFrame];
    [view addSubview:self];
    DLog(@"------------backScreen ");
}

- (void)removePlayer
{
    if (self.superview) {
        [self.link invalidate];
        self.link = nil;
        [self.player pause];
        [self.player.currentItem cancelPendingSeeks];
        [self.player.currentItem.asset cancelLoading];
        [self removeObserver];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didRemovePlay:)]) {
            [self.delegate playerView:self didRemovePlay:self.player];
        }
    }
}

- (void)autoFullScreenPlay
{
    if (_prePlayerIsFullScreen) {
        self.isFullScreen = YES;
    }
}

- (void)dealloc
{
    [self removePlayer];
}

- (void)videoPlayEnd
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didPlayEnd:)]) {
        [self.delegate playerView:self didPlayEnd:self.player];
    }
    [self.player seekToTime:kCMTimeZero];
    self.link.paused = YES;
    [self pause];
    _pausePlay.selected = YES;
    _playSwitch.selected = YES;
    _currentTimeLabel.text = @"00:00";
    _slider.sliderPercent = 0;
    self.isFirstPlay = YES;
}

- (void)applicationWillResignActive:(NSNotification *)noti
{
    if (_pausePlay.selected) { return;}
    [self pause];
}

#pragma mark - setXXX
- (void)setPlayer
{
    self.isFirstPlay = YES;
    [self.layer addSublayer:self.playerLayer];
    [self addObserver];
    [self insertSubview:self.maskView aboveSubview:self];
    [self insertSubview:self.circleLoadingView aboveSubview:self.maskView];
    _titleL.text = _title;
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateSlider)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.circleLoadingView startAnimating];
}

- (void)setMp4_url:(NSString *)mp4_url
{
    if (mp4_url == nil || mp4_url == NULL || [mp4_url isEqualToString:@""])
        return;
    _mp4_url = mp4_url;
    [self setPlayer];
}

- (void)setTitle:(NSString *)title
{
    if (title == nil || title == NULL || [title isEqualToString:@""])
        return;
    _title = title;
    _titleL.text = _title;
}

- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    if (isFullScreen) {
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.playerLayer.frame = self.bounds;
        self.maskView.frame = CGRectMake(0, 0, self.height, self.width);
        self.fullScreenBack.hidden = NO;
        [AppWindow addSubview:self];
    } else {
        self.transform = CGAffineTransformIdentity;
        self.frame = CGRectMake(0, self.currentOriginY, SCREEN_WIDTH, SCREEN_WIDTH * 0.56);
        self.playerLayer.frame = self.bounds;
        self.maskView.frame = CGRectMake(0, 0, self.width, self.height);
        self.fullScreenBack.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didExitFullScreen:)]) {
            [self.delegate playerView:self didExitFullScreen:self.player];
        }
    }
    [self addMaskSubViewFrame];
}


#pragma mark - timer
- (void)addMaskViewTimer
{
    [self removeMaskViewTimer];
    _toolViewShowTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEnd) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_toolViewShowTimer forMode:NSRunLoopCommonModes];
}

- (void)removeMaskViewTimer
{
    [_toolViewShowTimer invalidate];
    _toolViewShowTimer = nil;
    _toolViewShowTime = 0;
}

- (void)timerEnd
{
    _toolViewShowTime++;
    if (_toolViewShowTime == 2) {
        [self removeMaskViewTimer];
        _toolViewShowTime = 0;
        [self hideMaskView];
    }
}

- (void)pauseMaskStatue
{
    [self removeMaskViewTimer];
    if (self.player.rate == 0) {
        _pausePlay.selected = NO;
        _playSwitch.selected = NO;
    } else{
        _pausePlay.selected = YES;
        _playSwitch.selected = YES;
    }
    [self showMaskView];
}

// 更新进度条
- (void)updateSlider
{
    NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval total = CMTimeGetSeconds(self.player.currentItem.duration);
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (!_slider.isSliding) {
        _slider.sliderPercent = current/total;
    }
    
    if (current != self.lastTime) {
        [self.circleLoadingView stopAnimating];
        _currentTimeLabel.text = [self convertTimeToString:current];
        _totleTimeLabel.text = isnan(total) ? @"00:00" : [self convertTimeToString:total];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didPlaying:playTime:)]) {
            [self.delegate playerView:self didPlaying:self.player playTime:current];
        }
    }else{
        [self.circleLoadingView startAnimating];
    }
    // 记录当前播放时间 用于区分是否卡顿显示缓冲动画
    self.lastTime = current;
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

#pragma mark - hide / show
- (void)hideMaskView
{
    _pausePlay.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.02;
    } completion:^(BOOL finished) {
        _maskIsShow = NO;
    }];
}

- (void)showMaskView
{
    _pausePlay.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        _maskIsShow = YES;
    }];
}



#pragma mark - event
- (void)playOrPause
{
    self.isFirstPlay = NO;
    if (self.player.rate == 0) {
        _pausePlay.selected = NO;
        _playSwitch.selected = NO;
    } else{
        _pausePlay.selected = YES;
        _playSwitch.selected = YES;
    }
    if (!_playSwitch.selected) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)showMask
{
    if (_maskIsShow) {
        [self hideMaskView];
        return;
    }
    if (self.player.rate == 0) {
        _pausePlay.selected = YES;
    } else{
        _pausePlay.selected = NO;
    }
    _pausePlay.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        _maskIsShow = YES;
        if (self.player.rate != 0) {
            [self addMaskViewTimer];
        }
    }];
}

- (void)playCloseClick
{
    [self removePlayer];
}


- (void)clickFullScreen
{
    self.isFullScreen = !self.isFullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:self.isFullScreen];
    _prePlayerIsFullScreen = self.isFullScreen;
}

- (void)progressValueChange:(GYProgressSlider *)slider
{
    [self addMaskViewTimer];
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        NSTimeInterval duration = slider.sliderPercent * CMTimeGetSeconds(self.player.currentItem.duration);
        CMTime seekTime = CMTimeMake(duration, 1);
        
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
            if (finished) {
                NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
                _currentTimeLabel.text = [self convertTimeToString:current];
            }
        }];
    }
}

// 该方法废弃
- (void)handleSwipes:(UISwipeGestureRecognizer *)recognizer
{
    self.link.paused = YES;
    _current = CMTimeGetSeconds(self.player.currentTime);
    _total = CMTimeGetSeconds(self.player.currentItem.duration);
}

#pragma mark - toucheEvent
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isMove = NO;
    [super touchesBegan:touches withEvent:event];
    UITouch *oneTouch = [touches anyObject];
    _beginPoint = [oneTouch locationInView:oneTouch.view];
    _current = CMTimeGetSeconds(self.player.currentTime);
    _total = CMTimeGetSeconds(self.player.currentItem.duration);
}


//滑动快进/快退
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGFloat unit = _total / 300;
    UITouch *oneTouch = [touches anyObject];
    CGFloat offsetX = [oneTouch locationInView:oneTouch.view].x - _beginPoint.x;
    CGFloat progress = _slider.sliderPercent + (unit * offsetX)/_total;
    
    if (offsetX < 1 && offsetX > -1) {
        return;
    }
    _isMove = YES;
    if (self.isFullScreen) {
        self.link.paused = YES;
        self.screenSlider.hidden = NO;
        self.maskView.hidden = YES;
    }
    _screenSlider.current = _current + offsetX * unit;
    _screenSlider.total = _total;
    _screenSlider.slide = offsetX * unit;
    _screenSlider.progress = progress;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_isMove) {
        [self showMask];
        return;
    }
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval duration = _screenSlider.current;
        CMTime seekTime = CMTimeMake(duration, 1);
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
            if (finished) {
                weakSelf.screenSlider.hidden = YES;
                weakSelf.maskView.hidden = NO;
                weakSelf.link.paused = NO;
                NSTimeInterval current = CMTimeGetSeconds(weakSelf.player.currentTime);
                weakSelf.currentTimeLabel.text = [weakSelf convertTimeToString:current];
                _current = CMTimeGetSeconds(weakSelf.player.currentTime);
                _total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
            }
        }];
    }
}

#pragma mark - observe
- (void)addObserver
{
    if (self.playerItem) {
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObserver
{
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            DLog(@"准备播放");
            [self.circleLoadingView stopAnimating];
        } else if (status == AVPlayerStatusFailed){
            DLog(@"播放失败");
        } else {
            DLog(@"unknown");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval loadedTime = [self availableDurationWithplayerItem:playerItem];
        NSTimeInterval totalTime = CMTimeGetSeconds(playerItem.duration);
        if (!_slider.isSliding) {
            _slider.progressPercent = loadedTime/totalTime;
        }
    }
}

#pragma mark - observeMethod
// 获取缓冲进度
- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem
{
    NSArray * loadedTimeRanges = [playerItem loadedTimeRanges];
    // 获取缓冲区域
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    // 计算缓冲总进度
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

#pragma mark - lazy
- (AVPlayer *)player
{
    if (_player == nil) {
        _player = [AVPlayer playerWithPlayerItem: self.playerItem];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer
{
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerLayer;
}

- (AVPlayerItem *)playerItem
{
    if (!_playerItem) {
        if ([self.mp4_url rangeOfString:@"http"].location != NSNotFound) {
            _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.mp4_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        } else {
            AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.mp4_url] options:nil];
            _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        }
    }
    return _playerItem;
}

- (GYCircleLoadingView *)circleLoadingView
{
    if (!_circleLoadingView) {
        _circleLoadingView = [[GYCircleLoadingView alloc] initWithViewFrame:CGRectMake(self.width*0.5 - 20, self.height*0.5 - 20, 40, 40)];
    }
    return _circleLoadingView;
}

- (GYScreenProgressSlide *)screenSlider
{
    if (!_screenSlider) {
        _screenSlider = [[GYScreenProgressSlide alloc] initWithFrame:CGRectMake(_maskView.width*0.5 - 80, _maskView.height*0.5 - 60, 160, 120)];
        _screenSlider.hidden = YES;
        [self addSubview:_screenSlider];
    }
    return _screenSlider;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        
        [self addMaskAndSubView];
        [self addMaskSubViewFrame];
        
//        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMask)];
//        [_maskView addGestureRecognizer:tapGes];
        
//        UISwipeGestureRecognizer *leftGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//        leftGes.direction = UISwipeGestureRecognizerDirectionLeft;
//        [self addGestureRecognizer:leftGes];
//
//        UISwipeGestureRecognizer *rightGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//        rightGes.direction = UISwipeGestureRecognizerDirectionRight;
//        [self addGestureRecognizer:rightGes];

    }
    return _maskView;
}

#pragma mark - maskAndsubView
- (void)addMaskAndSubView
{
    [self addSubview:self.maskView];
    
    _playClose = [UIButton buttonWithType:UIButtonTypeCustom];
    _playClose.hidden = YES;
    [_playClose setImage:[UIImage imageNamed:@"play_close"] forState:UIControlStateNormal];
    [_playClose addTarget:self action:@selector(playCloseClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playClose];
    
    _topSideBar = [[UIImageView alloc] init];
    _topSideBar.userInteractionEnabled = YES;
    _topSideBar.image = [UIImage imageNamed:@"top_shadow.png"];
    [_maskView addSubview:_topSideBar];
    
    _fullScreenBack = [UIButton buttonWithType:UIButtonTypeCustom];
    _fullScreenBack.hidden = YES;
    [_fullScreenBack setImage:[UIImage imageNamed:@"play_back"] forState:UIControlStateNormal];
    [_fullScreenBack addTarget:self action:@selector(clickFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [_topSideBar addSubview:_fullScreenBack];
    
    _titleL = [[UILabel alloc] init];
    _titleL.font = [UIFont systemFontOfSize:16];
    _titleL.numberOfLines = 0;
    _titleL.textColor = [UIColor whiteColor];
    [_topSideBar addSubview:_titleL];
    
    _pausePlay = [UIButton buttonWithType:UIButtonTypeCustom];
    _pausePlay.hidden = YES;
    [_pausePlay setImage:[UIImage imageNamed:@"play_pause3"] forState:UIControlStateNormal];
    [_pausePlay setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateSelected];
    [_pausePlay addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    [_maskView addSubview:_pausePlay];
    
    _toolView = [[UIImageView alloc] init];
    _toolView.image = [UIImage imageNamed:@"bottom_shadow.png"];
    _toolView.userInteractionEnabled = YES;
    [_maskView addSubview:_toolView];
    
    _playSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playSwitch setImage:[UIImage imageNamed:@"video_pause.png"] forState:UIControlStateNormal];
    [_playSwitch setImage:[UIImage imageNamed:@"video_play.png"] forState:UIControlStateSelected];
    [_playSwitch addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_playSwitch];
    
    _currentTimeLabel = [[UILabel alloc] init];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:12];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    _currentTimeLabel.text = @"00:00";
    [_toolView addSubview:_currentTimeLabel];
    
    _totleTimeLabel = [[UILabel alloc] init];
    _totleTimeLabel.textColor = [UIColor whiteColor];
    _totleTimeLabel.font = [UIFont systemFontOfSize:12];
    _totleTimeLabel.textAlignment = NSTextAlignmentCenter;
    _totleTimeLabel.text = @"00:00";
    [_toolView addSubview:_totleTimeLabel];
    
    _slider = [[GYProgressSlider alloc] initWithFrame:CGRectZero direction:RHSliderDirectionHorizonal];
    [_slider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    _slider.enabled = YES;
    [_toolView addSubview:_slider];

    _fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullScreen setImage:[UIImage imageNamed:@"screen_unfull"] forState:UIControlStateNormal];
    [_fullScreen setImage:[UIImage imageNamed:@"screen_full"] forState:UIControlStateSelected];
    [_fullScreen addTarget:self action:@selector(clickFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_fullScreen];
}

- (void)addMaskSubViewFrame
{
    _screenSlider.frame = CGRectMake(_maskView.width*0.5 - 90, _maskView.height*0.5 - 60, 180, 120);
    _circleLoadingView.frame = CGRectMake(_maskView.width*0.5 - 20, _maskView.height*0.5 - 20, 40, 40);
    _playClose.frame = CGRectMake(0, 0, 25, 25);
    _topSideBar.frame = CGRectMake(0, 0, _maskView.width, 50);
    _fullScreenBack.frame = CGRectMake(10, 10, 40, 40);
    if (_fullScreenBack.hidden) {
        _titleL.frame = CGRectMake(10, 10, _maskView.width-20, 40);
    } else{
        _titleL.frame = CGRectMake(50, 10, _maskView.width-20, 40);
    }
    _pausePlay.frame = CGRectMake(_maskView.width*0.5 - 25, _maskView.height*0.5 - 25, 50, 50);
    _toolView.frame = CGRectMake(0, _maskView.height - 37, _maskView.width, 37);
    _playSwitch.frame = CGRectMake(10, 10, 17, 17);
    _currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(_playSwitch.frame) + 10, 0, 50, _toolView.height);
    _fullScreen.frame = CGRectMake(_maskView.width - 10 - 37, 0, 37, 37);
    _totleTimeLabel.frame = CGRectMake(CGRectGetMinX(_fullScreen.frame) - 10 - 50, 0, 50,  _toolView.height);
    _slider.frame = CGRectMake(CGRectGetMaxX(_currentTimeLabel.frame) + 10, 0, CGRectGetMinX(_totleTimeLabel.frame) - CGRectGetMaxX(_currentTimeLabel.frame) - 10, _toolView.height);
}



@end
