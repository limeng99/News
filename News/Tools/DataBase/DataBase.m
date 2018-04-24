//
//  DataBase.m
//  News
//
//  Created by 李萌萌 on 2018/4/17.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"
#import "State.h"
#import "City.h"
#import "DataModel.h"
#import "CollectModel.h"

#define DBFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:@"db.sqlite"]

// 版本控制
static NSString *_version = @"1.2";
static FMDatabaseQueue  *_queue = nil;
@implementation DataBase

+ (void)dataBaseConfig
{
    
    NSLog(@"%@",DBFilePath);
    // 版本控制
    [self versionControl];
    
    // 判断是否存在
    BOOL isDir;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:DBFilePath isDirectory:&isDir]) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:DBFilePath];
        return;
    }
    
    // 实例化FMDataBase对象
    _queue = [FMDatabaseQueue databaseQueueWithPath:DBFilePath];
    
    // 初始化数据表
    NSString *stateSql = @"CREATE TABLE IF NOT EXISTS t_state (stateId INTEGER  NOT NULL ,stateName VARCHAR(64)) ";
    NSString *citySql = @"CREATE TABLE  IF NOT EXISTS t_city (cityId INTEGER  NOT NULL ,stateId INTEGER,cityName VARCHAR(64))";
    NSString *newsSql = @"CREATE TABLE IF NOT EXISTS t_news (newsId INTEGER primary key autoincrement, title VARCHAR(64),docid VARCHAR(64),time VARCHAR(64))";

    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:stateSql];
        [db executeUpdate:citySql];
        [db executeUpdate:newsSql];
    }];
    
    // city / state
    [self stateAndCityConfig];
}

+ (void)versionControl
{
    NSString *version = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    if (!version) {
        [[NSUserDefaults standardUserDefaults] setObject:_version forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    if (![version isEqualToString:_version]) {
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:DBFilePath]) {
            [manager removeItemAtPath:DBFilePath error:nil];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_version forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSArray *)getStateAndCityFromPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    return [NSArray arrayWithContentsOfFile:path];
}

+ (void)stateAndCityConfig
{
    NSArray *arr = [self getStateAndCityFromPlist];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        for (NSInteger i = 0; i < arr.count; i++) {
            State *state = [State modelWithDictionary:arr[i]];
            state.stateId = i+1;
            NSString *stateSql = @"INSERT INTO t_state (stateId,stateName) VALUES (?,?)";
            [db executeUpdate:stateSql, @(state.stateId), state.stateName];
            
            state.citys = [NSMutableArray array];
            NSInteger j = 1;
            for (NSString *cityStr in arr[i][@"cities"]) {
                City *city = [[City alloc] init];
                city.cityName = cityStr;
                city.cityId = j;
                [state.citys addObject:city];
                j++;
                NSString *citySql = @"INSERT INTO t_city (cityId,stateId,cityName) VALUES (?,?,?)";
                [db executeUpdate:citySql, @(city.cityId) ,@(state.stateId), city.cityName];
            }
        }
    }];
}

+ (NSArray *)getStates
{
    NSMutableArray *states = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *res = [db executeQuery:@"SELECT * FROM t_state"];
        while ([res next]) {
            State *state = [[State alloc] init];
            state.stateId = [[res stringForColumn:@"stateId"] integerValue];
            state.stateName = [res stringForColumn:@"stateName"];
            
            NSMutableArray *citys = [NSMutableArray array];
            FMResultSet *resCity = [db executeQuery:@"SELECT * FROM t_city WHERE stateId = ?", @(state.stateId)];
            while ([resCity next]) {
                City *city = [[City alloc] init];
                city.cityId = [[resCity stringForColumn:@"cityId"] integerValue];
                city.cityName = [resCity stringForColumn:@"cityName"];
                [citys addObject:city];
            }
            state.citys = [citys mutableCopy];
            [states addObject:state];
        }
    }];
    return [states copy];
}

+ (void)newsCollect:(DataModel *)newsData
{
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"INSERT INTO t_news (title,docid,time) VALUES (?,?,?)";
        NSTimeInterval time = [[NSDate date] timeIntervalSinceNow];
        [db executeUpdate:sql, newsData.title, newsData.docid, @(time)];
    }];
}

+ (BOOL)queryCollect:(DataModel *)newsData
{
    __block BOOL flag = NO;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql =  @"SELECT * FROM t_news WHERE docid = ?";
        FMResultSet *res = [db executeQuery:sql, newsData.docid];
        flag = [res next];
    }];
    return flag;
}

+ (NSArray *)getCollects
{
    NSMutableArray *collects = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *res = [db executeQuery:@"SELECT * FROM t_news"];
        while ([res next]) {
            CollectModel *model = [[CollectModel alloc] init];
            model.title = [res stringForColumn:@"title"] ;
            model.docid = [res stringForColumn:@"docid"];
            model.time = [res stringForColumn:@"time"];
            [collects addObject:model];
        }
    }];
    return [collects copy];
}

+ (void)deleteCollect:(DataModel *)newsData
{
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"DELETE FROM t_news WHERE docid = ?";
        [db executeUpdate:sql, newsData.docid];
    }];
}


@end
