//
//  AppGlobal.m
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "AppGlobal.h"

static NSString *_province = @"北京";
static NSString *_city = @"北京";
@implementation AppGlobal

+ (void)setProvince:(NSString *)province
{
    NSRange range = [province rangeOfString:@"市"];
    if (range.location != NSNotFound) {
        province = [province substringToIndex:range.location];
    }
    NSRange range2 = [province rangeOfString:@"省"];
    if (range2.location != NSNotFound) {
        province = [province substringToIndex:range2.location];
    }
    if ([province isEqualToString:@"广西壮族自治区桂林"]) {
        province = @"广西";
    }
    _province = province;
}

+ (NSString *)getProvince
{
    return _province;
}

+ (void)setCity:(NSString *)city
{
    NSRange range = [city rangeOfString:@"市"];
    if (range.location != NSNotFound) {
        city = [city substringToIndex:range.location];
    }
    _city = city;
}

+ (NSString *)getCity
{
    return _city;
}

@end
