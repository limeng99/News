//
//  TopBannerModel.h
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopBannerModel : NSObject

/**
 *  滚动条图片
 */
@property (nonatomic , copy) NSString *imgsrc;
/**
 *  滚动条标题
 */
@property (nonatomic , copy) NSString *title;
/**
 *  链接
 */
@property (nonatomic , copy) NSString *url;

@property (nonatomic , copy) NSString *subtitle;

/**
 *  imgurl  详细图片
 */
@property (nonatomic , copy) NSString *imgurl;

/**
 *  详细内容
 */
@property (nonatomic , copy) NSString *note;
/**
 *  标题
 */
@property (nonatomic , copy) NSString *setname;

@property (nonatomic , copy) NSString *imgtitle;



@end
