//
//  ThemeManager.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "ThemeManager.h"

static id _instance;

@implementation ThemeManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initTheme];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (void)initTheme
{
    self.themeName = [self currentTheme];
    self.themePath = [Bundle_Path_Of_ThemeResource stringByAppendingPathComponent:self.themeName];
    self.themeColor = [UIColor colorWithPatternImage:[self themedImageWithName:@"navigationBar"]];
    self.oldColor = [UIColor whiteColor];
}

- (NSString *)currentTheme
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"theme"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"normal" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return @"normal";
    } else {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"theme"];
    }
}

- (void)changeThemeWithName:(NSString *)themeName
{
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:@"theme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self initTheme];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notice_Theme_Changed object:themeName];
}

- (UIImage *)themedImageWithName:(NSString *)imgName
{
    NSString *newImagePath = [self.themePath stringByAppendingPathComponent:imgName];
    return [UIImage imageWithContentsOfFile:newImagePath];
}

- (NSArray *)listOfAllTheme
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *listArray = [manager contentsOfDirectoryAtPath:Bundle_Path_Of_ThemeResource error:nil];
    return listArray;
}


@end
