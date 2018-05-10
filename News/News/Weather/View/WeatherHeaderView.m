//
//  WeatherHeaderView.m
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "WeatherHeaderView.h"
#import "WeatherModel.h"

@interface WeatherHeaderView()

@property (nonatomic , weak) UIImageView *imageV;
@property (nonatomic , weak) UILabel *cityLabel;
@property (nonatomic , weak) UILabel *dateLabel;
@property (nonatomic , weak) UIImageView *todayImg;
@property (nonatomic , weak) UILabel *todayLabel;
@property (nonatomic , weak) UILabel *temLabel;
@property (nonatomic , weak) UILabel *climateLabel;
@property (nonatomic , weak) UILabel *windLabel;
@property (nonatomic , weak) UILabel *pmLabel;

@end

@implementation WeatherHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    //背景
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.bounds];
    imageV.image = [UIImage imageNamed:@"MoRen"];
    [self addSubview:imageV];
    self.imageV = imageV;
    
    //返回按钮
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = CGRectMake(5, SafeAreaStateHeight+5, 50, 50);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"weather_back"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backbtn];
    
    //城市名
    CGFloat cityLabelW = 50;
    CGFloat cityLabelH = 20;
    CGFloat cityLabelX = (SCREEN_WIDTH - cityLabelW)/2;
    CGFloat cityLabelY = SafeAreaStateHeight+10;
    UILabel *cityLabel = [[UILabel alloc]init];
    [self setupWithLabel:cityLabel frame:CGRectMake(cityLabelX, cityLabelY, cityLabelW, cityLabelH) FontSize:17 view:self textAlignment:NSTextAlignmentCenter];
    self.cityLabel = cityLabel;
    
    //定位图标
    UIButton *locB = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityLabel.frame)+5, SafeAreaStateHeight+10, 20, 20)];
    [locB setImage:[UIImage imageNamed:@"weather_location"] forState:UIControlStateNormal];
    [locB addTarget:self action:@selector(locClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:locB];
    
    //日期
    CGFloat dateLW = 110;
    CGFloat dateLH = 20;
    CGFloat dateLX = (SCREEN_WIDTH - dateLW)/2;
    CGFloat dateLY = CGRectGetMaxY(locB.frame) + 10;
    UILabel *dateLabel = [[UILabel alloc]init];
    [self setupWithLabel:dateLabel frame:CGRectMake(dateLX, dateLY, dateLW, dateLH) FontSize:14 view:self textAlignment:NSTextAlignmentCenter];
    self.dateLabel = dateLabel;
    
    //天气图片
    CGFloat todayImgW = 100;
    CGFloat todayImgH = todayImgW * 1.35;
    CGFloat todayImgX = SCREEN_WIDTH/2 - todayImgW - 10;
    CGFloat todayImgY = (SCREEN_HEIGHT - todayImgH)/2 - todayImgH/2;
    UIImageView *todayImg = [[UIImageView alloc]initWithFrame:CGRectMake(todayImgX, todayImgY, todayImgW, todayImgH)];
    [self addSubview:todayImg];
    self.todayImg = todayImg;
    
    //今日温度
    CGFloat todayLabelW = 100;
    CGFloat todayLabelH = 24;
    CGFloat todayLabelX = todayImg.left;
    CGFloat todayLabelY = todayImg.top + 38;
    UILabel *todayLabel = [[UILabel alloc] init];
    [self setupWithLabel:todayLabel frame:CGRectMake(todayLabelX, todayLabelY, todayLabelW, todayLabelH) FontSize:20 view:self textAlignment:NSTextAlignmentCenter];
    self.todayLabel = todayLabel;
    
    //温度
    CGFloat temLabelW = 200;
    CGFloat temLabelH = 30;
    CGFloat temLabelX = SCREEN_WIDTH/2;
    CGFloat temLabelY = todayImgY;
    UILabel *temLabel = [[UILabel alloc]init];
    [self setupWithLabel:temLabel frame:CGRectMake(temLabelX, temLabelY, temLabelW, temLabelH) FontSize:30 view:self textAlignment:NSTextAlignmentLeft];
    self.temLabel = temLabel;
    
    //天气
    UILabel *climateLabel = [[UILabel alloc]init];
    [self setupWithLabel:climateLabel frame: CGRectMake(temLabelX, CGRectGetMaxY(temLabel.frame), temLabelW, 20) FontSize:14 view:self textAlignment:NSTextAlignmentLeft];
    self.climateLabel = climateLabel;
    
    //风
    UILabel *windLabel = [[UILabel alloc]init];
    [self setupWithLabel:windLabel frame:CGRectMake(temLabelX, CGRectGetMaxY(climateLabel.frame), temLabelW, 20) FontSize:14 view:self textAlignment:NSTextAlignmentLeft];
    self.windLabel = windLabel;
    
    //PM2.5
    UILabel *pmLabel = [[UILabel alloc]init];
    [self setupWithLabel:pmLabel frame:CGRectMake(temLabelX, CGRectGetMaxY(windLabel.frame), temLabelW, 20) FontSize:14 view:self textAlignment:NSTextAlignmentLeft];
    self.pmLabel = pmLabel;
    
    
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    WeatherModel *model = dataArray[0];
    
    [self.imageV setImageWithURL:[NSURL URLWithString:model.nbg2] placeholder:[UIImage imageNamed:@"MoRen"]];
    
    NSString *city = [AppGlobal getCity];
    self.cityLabel.text = city;

    NSString *dtstr = [model.dt substringFromIndex:5];
    NSString *datestr = [dtstr stringByAppendingFormat:@"日 %@",model.week];
    datestr = [datestr stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    self.dateLabel.text = datestr;
    //天气图片
    if ([model.climate isEqualToString:@"雷阵雨"]) {
        self.todayImg.image = [UIImage imageNamed:@"thunder"];
    }else if ([model.climate isEqualToString:@"晴"]){
        self.todayImg.image = [UIImage imageNamed:@"sun"];
    }else if ([model.climate isEqualToString:@"多云"]){
        self.todayImg.image = [UIImage imageNamed:@"sunandcloud"];
    }else if ([model.climate isEqualToString:@"阴"]){
        self.todayImg.image = [UIImage imageNamed:@"cloud"];
    }else if ([model.climate hasSuffix:@"雨"]){
        self.todayImg.image = [UIImage imageNamed:@"rain"];
    }else if ([model.climate hasSuffix:@"雪"]){
        self.todayImg.image = [UIImage imageNamed:@"snow"];
    }else{
        self.todayImg.image = [UIImage imageNamed:@"sandfloat"];
    }
    
    // 今日天气
    self.todayLabel.text = [NSString stringWithFormat:@"%@℃",model.rt_temperature];
    
    //图片动画效果
    [UIView animateKeyframesWithDuration:0.9 delay:0.5 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.todayImg.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.9 animations:^{
            self.todayImg.transform = CGAffineTransformIdentity;
        }];
    }];
    
    //温度
    model.temperature = [model.temperature stringByReplacingOccurrencesOfString:@"C" withString:@""];
    self.temLabel.text = model.temperature;
    //天气
    self.climateLabel.text = model.climate;
    //风
    self.windLabel.text = model.wind;
    //pm
    NSString *aqi;
    int pm = model.pm2_5.intValue;
    if (pm < 50) {
        aqi = @"优";
    }else if (pm < 100){
        aqi = @"良";
    }else{
        aqi = @"差";
    }
    NSString *pmstr = @"PM2.5";
    pmstr = [pmstr stringByAppendingFormat:@"   %d   %@",pm,aqi];
    self.pmLabel.text = pmstr;
}

- (void)locClick
{
    if (self.localBlock) {
        self.localBlock();
    }
}

- (void)back
{
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)setupWithLabel:(UILabel *)label frame:(CGRect)frame FontSize:(CGFloat)fontSize view:(UIView *)view textAlignment:(NSTextAlignment)textAlignment
{
    label.frame = frame;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = textAlignment;
    [view addSubview:label];
}


@end
