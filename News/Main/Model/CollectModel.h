//
//  CollectModel.h
//  News
//
//  Created by 李萌萌 on 2018/4/19.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject

/**
 *  新闻标题
 */
@property (nonatomic , copy) NSString * title;

/**
 *  新闻ID
 */
@property (nonatomic , copy) NSString * docid;

/**
 *  收藏的时间
 */
@property (nonatomic , copy) NSString * time;

@end
