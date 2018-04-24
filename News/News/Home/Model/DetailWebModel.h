//
//  DetailWebModel.h
//  News
//
//  Created by 李萌萌 on 2018/4/16.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailWebModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 内容 */
@property (nonatomic, copy) NSString *body;
/** 配图 */
@property (nonatomic, strong) NSMutableArray *images;

@end
