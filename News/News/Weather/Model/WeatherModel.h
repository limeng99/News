//
//  WeatherModel.h
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (nonatomic , copy) NSString * wind;         //风
@property (nonatomic , copy) NSString * date;         //日期
@property (nonatomic , copy) NSString * climate;      //天气
@property (nonatomic , copy) NSString * temperature;  //温度
@property (nonatomic , copy) NSString * week;         //星期几

@property (nonatomic , copy) NSString * nbg2;         //背景图
@property (nonatomic , copy) NSString * aqi;          //空气质量
@property (nonatomic , copy) NSString * pm2_5;
@property (nonatomic , copy) NSString * rt_temperature; //室温
@property (nonatomic , copy) NSString * dt;            // 时间


@end
