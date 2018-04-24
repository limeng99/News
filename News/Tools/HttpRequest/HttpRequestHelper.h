//
//  HttpRequestHelper.h
//  iKair
//
//  Created by limeng on 14-6-2.
//  Copyright (c) 2014年 limeng. All rights reserved.
//

/**
 *  HTTP基本操作功能类
 */
#import <Foundation/Foundation.h>

@interface HttpRequestHelper : NSObject

/** 是否有网 */
@property (nonatomic, assign) BOOL isNet;
/** 是否连接wifi */
@property (nonatomic, assign) BOOL isWifi;


// 实例化
+ (instancetype)sharedHttpRequest;

// 取消请求
- (void)cancelAllHttpRequest;

/**
 *  请求数据
 *
 *  @param url            url
 *  @param Params         需要POST的参数
 *  @param didFinishBlock 回调
 */
-(void) postRequestUrl:(NSString *)url
             setParams:(NSDictionary *)Params
             didFinish:(void(^)(id json,NSError *error))didFinishBlock;

/**
 *  POST数据
 *
 *  @param url            url
 *  @param params         需要POST的参数
 *  @param didFinishBlock 回调
 */
-(void) postRequestUrl:(NSString *)url
             setParams:(NSDictionary *)params
          contentTypes:(NSSet *)acceptableContentTypes
             didFinish:(void(^)(id json,NSError *error))didFinishBlock;


/**
 *  Get数据
 *
 *  @param url              url
 *  @param didFinishBlock   回调
 */
-(void) getRequestUrl:(NSString *)url
            setParams:(NSDictionary *)params
            didFinish:(void(^)(id json,NSError *error))didFinishBlock;

/**
 *  Get数据
 *
 *  @param url              url
 *  @param didFinishBlock   回调
 */
-(void) getRequestUrl:(NSString *)url
            setParams:(NSDictionary *)params
         contentTypes:(NSSet *)acceptableContentTypes
            didFinish:(void(^)(id json,NSError *error))didFinishBlock;


/**
 *  上传多张图片到服务器
 *
 *  @param url            url
 *  @param params         参数
 *  @param imageDatas     data数组
 *  @param didFinishBlock 回调
 */
-(void)postImagesToUrl:(NSString *)url
             setParams:(NSDictionary *)params
            ImageDatas:(NSMutableArray *)imageDatas
              progress:(void(^)(NSProgress *))progressBlock
             didFinish:(void(^)(id json,NSError *error))didFinishBlock;
@end
