//
//  ThemeManager.h
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#define Bundle_Of_ThemeResource @"ThemeResource"
#define Bundle_Path_Of_ThemeResource [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Bundle_Of_ThemeResource]

#define Notice_Theme_Changed @"Notice_Theme_Changed"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *themeName;
@property (nonatomic, copy) NSString *themePath;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) UIColor *oldColor;

+ (ThemeManager*)sharedInstance;
-(void)changeThemeWithName:(NSString*)themeName;
- (UIImage*)themedImageWithName:(NSString*)imgName;
-(NSArray *)listOfAllTheme;


@end
