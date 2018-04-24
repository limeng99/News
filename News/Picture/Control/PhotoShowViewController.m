//
//  PhotoShowViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "PhotoShowViewController.h"
#import "Photo.h"
#import "SDCycleScrollView.h"

@interface PhotoShowViewController ()

@property (nonatomic, strong) SDCycleScrollView *scrollV;

@end

@implementation PhotoShowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    for (Photo *photo in _photoArray) {
        [images addObject:photo.image_url];
        [titles addObject:photo.title];
    }
    
    _scrollV = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollV.backgroundColor = [UIColor blackColor];
    _scrollV.titleLabelHeight = 60;
    _scrollV.imageURLStringsGroup = images;
    _scrollV.titlesGroup = titles;
    _scrollV.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    _scrollV.autoScroll = NO;
    _scrollV.showPageControl = NO;
    [self.view addSubview:_scrollV];
    
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = CGRectMake(5, 25, 40, 40);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"weather_back"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
