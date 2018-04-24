//
//  State.h
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface State : NSObject

@property (nonatomic, assign) NSInteger stateId;
@property (nonatomic, copy) NSString *stateName;
@property (nonatomic, strong) NSMutableArray *citys;

@end
