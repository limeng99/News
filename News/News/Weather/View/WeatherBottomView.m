//
//  WeatherBottomView.m
//  News
//
//  Created by 李萌萌 on 2018/4/18.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "WeatherBottomView.h"
#import "WeatherModel.h"

@implementation WeatherBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT - (SCREEN_WIDTH/3 * 1.8), SCREEN_WIDTH, SCREEN_WIDTH/3 * 1.8);
        self.backgroundColor = RGBA(1, 1, 1, 0.2);
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    [self removeAllSubviews];
    _dataArray = dataArray;
    [dataArray enumerateObjectsUsingBlock:^(WeatherModel *model, NSUInteger index, BOOL * _Nonnull stop) {
        if (index > 0 && index < 4) {
            CGFloat vcW = SCREEN_WIDTH/3;
            CGFloat vcH = vcW * 1.8;
            CGFloat vcX = (index - 1) * vcW;
            CGFloat vcY = 0;
            UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(vcX, vcY, vcW, vcH)];
            [self addSubview:vc];
            
            //星期
            UILabel *weekLabel = [[UILabel alloc]init];
            [self setupWithLabel:weekLabel frame:CGRectMake(0, 20, vcW, 20) FontSize:14 view:vc textAlignment:NSTextAlignmentCenter];
            //图片
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((vcW-60)/2, CGRectGetMaxY(weekLabel.frame) + 5, 60, 60*1.35)];
            [vc addSubview:img];
            //温度
            UILabel *temLabel = [[UILabel alloc]init];
            [self setupWithLabel:temLabel frame:CGRectMake(0, CGRectGetMaxY(img.frame), vcW, 20) FontSize:20 view:vc textAlignment:NSTextAlignmentCenter];
            //风，天气
            UILabel *cliwindLabel = [[UILabel alloc]init];
            cliwindLabel.numberOfLines = 0;
            [self setupWithLabel:cliwindLabel frame:CGRectMake(0, CGRectGetMaxY(temLabel.frame), vcW, 50) FontSize:12 view:vc textAlignment:NSTextAlignmentCenter];
            
            //星期
            weekLabel.text = model.week;
            //图片
            if ([model.climate isEqualToString:@"雷阵雨"]) {
                img.image = [UIImage imageNamed:@"thunder"];
            }else if ([model.climate isEqualToString:@"晴"]){
                img.image = [UIImage imageNamed:@"sun"];
            }else if ([model.climate isEqualToString:@"多云"]){
                img.image = [UIImage imageNamed:@"sunandcloud"];
            }else if ([model.climate isEqualToString:@"阴"]){
                img.image = [UIImage imageNamed:@"cloud"];
            }else if ([model.climate hasSuffix:@"雨"]){
                img.image = [UIImage imageNamed:@"rain"];
            }else if ([model.climate hasSuffix:@"雪"]){
                img.image = [UIImage imageNamed:@"snow"];
            }else{
                img.image = [UIImage imageNamed:@"sandfloat"];
            }
            //温度
            NSString *tem = [model.temperature stringByReplacingOccurrencesOfString:@"C" withString:@""];
            temLabel.text = tem;
            //风，天气
            cliwindLabel.text = [model.climate stringByAppendingFormat:@"\n%@",model.wind];
        }
    }];
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
