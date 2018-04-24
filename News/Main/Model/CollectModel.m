//
//  CollectModel.m
//  News
//
//  Created by 李萌萌 on 2018/4/19.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel


- (void)setTime:(NSString *)time
{
    NSDateFormatter *fromatter = [[NSDateFormatter alloc] init];
    [fromatter setDateFormat:@"yyyy-MM-dd hh:dd:ss"];
    fromatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[time doubleValue]];
    _time =  [fromatter stringFromDate:date];
}

@end
