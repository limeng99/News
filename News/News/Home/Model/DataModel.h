//
//  DataModel.h
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject


/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  来源
 */
@property (nonatomic , copy) NSString *source;
/**
 *  多图数组
 */
@property (nonatomic,strong)NSArray *imgextra;
@property (nonatomic,copy) NSString *photosetID;
@property (nonatomic,copy)NSNumber *hasHead;
@property (nonatomic,copy)NSNumber *hasImg;
@property (nonatomic,copy) NSString *lmodify;
@property (nonatomic,copy) NSString *Template;
@property (nonatomic,copy) NSString *skipType;
/**
 *  跟帖人数
 */
@property (nonatomic,copy)NSNumber *replyCount;
@property (nonatomic,copy)NSNumber *votecount;
@property (nonatomic,copy) NSString *alias;
/**
 *  新闻ID
 */
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,assign)BOOL hasCover;
@property (nonatomic,copy)NSNumber *hasAD;
@property (nonatomic,copy)NSNumber *priority;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,strong)NSArray *videoID;
/**
 *  图片连接
 */
@property (nonatomic,copy) NSString *imgsrc;
@property (nonatomic,assign)BOOL hasIcon;
@property (nonatomic,copy) NSString *ename;
@property (nonatomic,copy) NSString *skipID;
@property (nonatomic,copy)NSNumber *order;
/**
 *  描述
 */
@property (nonatomic,copy) NSString *digest;

@property (nonatomic,strong)NSArray *editor;


@property (nonatomic,copy) NSString *url_3w;
@property (nonatomic,copy) NSString *specialID;
@property (nonatomic,copy) NSString *timeConsuming;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *adTitle;
@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *TAGS;
@property (nonatomic,copy) NSString *TAG;
/**
 *  大图样式
 */
@property (nonatomic,copy)NSNumber *imgType;
@property (nonatomic,strong)NSArray *specialextra;


@property (nonatomic,copy) NSString *boardid;
@property (nonatomic,copy) NSString *commentid;
@property (nonatomic,copy)NSNumber *speciallogo;
@property (nonatomic,copy) NSString *specialtip;
@property (nonatomic,copy) NSString *specialadlogo;

@property (nonatomic,copy) NSString *pixel;
@property (nonatomic,strong)NSArray *applist;

@property (nonatomic,copy) NSString *wap_portal;
@property (nonatomic,copy) NSString *live_info;
@property (nonatomic,copy) NSString *ads;
@property (nonatomic,copy) NSString *videosource;


@end
