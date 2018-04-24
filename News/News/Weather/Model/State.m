//
//  State.m
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "State.h"
#import "City.h"

@implementation State

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary
{
    State *state = [super modelWithDictionary:dictionary];
    state.stateName = dictionary[@"state"];
//    state.citys = [NSMutableArray array];
//    NSInteger i = 0;
//    for (NSString *cityStr in dictionary[@"cities"]) {
//        City *city = [[City alloc] init];
//        city.cityName = cityStr;
//        city.cityId = i;
//        i ++;
//        [state.citys addObject:city];
//    }
    return state;
}

@end
