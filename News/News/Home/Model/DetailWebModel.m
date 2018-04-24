//
//  DetailWebModel.m
//  News
//
//  Created by 李萌萌 on 2018/4/16.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "DetailWebModel.h"
#import "DetailImageWebModel.h"

@implementation DetailWebModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary
{
    DetailWebModel *model = [super modelWithDictionary:dictionary];
    model.images = [NSMutableArray array];
    for (NSDictionary *dic in dictionary[@"img"]) {
        DetailImageWebModel *imageModel = [DetailImageWebModel modelWithDictionary:dic];
        [model.images addObject:imageModel];
    }
    return model;
}



@end
