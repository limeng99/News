//
//  TabbarViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/10.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "TabbarViewController.h"
#import "NavigationController.h"
#import "SCNavTabBarController.h"
#import "PhotoViewController.h"
#import "VideoViewController.h"
#import "MeViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initControl];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor redColor];
}

- (void)initControl
{
    SCNavTabBarController  *new = [[SCNavTabBarController alloc]init];
    [self setupChildViewController:new title:@"新闻" imageName:@"tabbar_news" selectedImage:@"tabbar_news_hl"];
    
    PhotoViewController *photo = [[PhotoViewController alloc]init];
    [self setupChildViewController:photo title:@"图片" imageName:@"tabbar_picture" selectedImage:@"tabbar_picture_hl"];
    
    VideoViewController *video = [[VideoViewController alloc]init];
    [self setupChildViewController:video title:@"视频" imageName:@"tabbar_video" selectedImage:@"tabbar_video_hl"];
    
    MeViewController *me = [[MeViewController alloc]init];
    [self setupChildViewController:me title:@"我的" imageName:@"tabbar_setting" selectedImage:@"tabbar_setting_hl"];
    
}

- (void)setupChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedName
{
    childVC.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

@end
