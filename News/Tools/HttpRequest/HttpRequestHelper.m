//
//  HttpRequestHelper.m
//  iKair
//
//  Created by limeng on 14-6-2.
//  Copyright (c) 2014年 limeng. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "AFNetworking.h"

// 超时时间
static const NSInteger AFNET_TIMEOUT = 30;
// 单例
static HttpRequestHelper *httpRequestHelper = nil;

@interface HttpRequestHelper ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFNetworkReachabilityManager *netManager;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSMutableArray *tasks;

@end

@implementation HttpRequestHelper

// 实例化
+ (instancetype)sharedHttpRequest
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpRequestHelper = [[HttpRequestHelper alloc] init];
    });
    return httpRequestHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = AFNET_TIMEOUT;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                              @"application/json",
                                                              @"text/plain",
                                                              @"text/javascript",
                                                              @"text/json",
                                                              @"text/html", nil];
        
        _netManager = [AFNetworkReachabilityManager manager];
        [_netManager startMonitoring];
        [_netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    _isNet = YES;
                    _isWifi = NO;
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    _isNet = NO;
                    _isWifi = NO;
                }
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    _isNet = YES;
                    _isWifi = NO;
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    _isNet = YES;
                    _isWifi = YES;
                }
                    break;
            }
        }];

    }
    return self;
}

// 懒加载
- (NSMutableArray *)tasks
{
    if (_tasks == nil) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

// 取消请求
- (void)cancelAllHttpRequest
{
    if (self.tasks.count == 0) return;
    [self.tasks makeObjectsPerformSelector:@selector(cancel)];
}

/**
 *  POST数据
 *
 *  @param url            url
 *  @param params         需要POST的参数
 *  @param didFinishBlock 回调
 */
- (void) postRequestUrl:(NSString *)url
             setParams:(NSDictionary *)params
             didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    [self postRequestUrl:url setParams:params contentTypes:nil didFinish:didFinishBlock];
}

/**
 *  POST数据
 *
 *  @param url            url
 *  @param params         需要POST的参数
 *  @param didFinishBlock 回调
 */
- (void) postRequestUrl:(NSString *)url
             setParams:(NSDictionary *)params
          contentTypes:(NSSet *)acceptableContentTypes
             didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    if (acceptableContentTypes) {
        _manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    _task = [_manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        if (didFinishBlock) {
            didFinishBlock(responseObject,nil);
        }
        [_tasks removeObject:_task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (didFinishBlock) {
            didFinishBlock(nil,error);
        }
        [_tasks removeObject:_task];
    }];
    [self.tasks addObject:_task];
}

/**
 *  Get数据
 *
 *  @param url              url
 *  @param didFinishBlock   回调
 */
- (void) getRequestUrl:(NSString *)url
             setParams:(NSDictionary *)params
            didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    [self getRequestUrl:url setParams:params contentTypes:nil didFinish:didFinishBlock];
}

/**
 *  Get数据
 *
 *  @param url              url
 *  @param didFinishBlock   回调
 */
- (void) getRequestUrl:(NSString *)url
             setParams:(NSDictionary *)params
         contentTypes:(NSSet *)acceptableContentTypes
            didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    if (acceptableContentTypes) {
        _manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    _task = [_manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
//        NSLog(@"%ld url:%@,Success: %@",(long)[(NSHTTPURLResponse *)task.response statusCode],url, responseObject);
        if (didFinishBlock) {
            didFinishBlock(responseObject,nil);
        }
        [_tasks removeObject:_task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (didFinishBlock) {
            didFinishBlock(nil,error);
        }
        [_tasks removeObject:_task];
    }];
    [self.tasks addObject:_task];

}

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
             didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    _manager.requestSerializer.timeoutInterval = AFNET_TIMEOUT*2;
    _task = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(NSInteger i = 0; i < imageDatas.count; i++)
        {
            NSData * imageData = [imageDatas objectAtIndex:i];
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.png" mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        NSLog(@"url:%@,Success: %@",url, responseObject);
        if (didFinishBlock) {
            didFinishBlock(responseObject,nil);
        }
        [_tasks removeObject:_task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (didFinishBlock) {
            didFinishBlock(nil,error);
        }
        [_tasks removeObject:_task];
    }];
    [self.tasks addObject:_task];
}


@end
