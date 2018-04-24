//
//  DetailImageWebModel.h
//  News
//
//  Created by 李萌萌 on 2018/4/16.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailImageWebModel : NSObject

/** url */
@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;

@end
