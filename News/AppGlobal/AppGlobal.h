//
//  AppGlobal.h
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppGlobal : NSObject

+ (void)setProvince:(NSString *)province;
+ (NSString *)getProvince;

+ (void)setCity:(NSString *)city;
+ (NSString *)getCity;


@end
