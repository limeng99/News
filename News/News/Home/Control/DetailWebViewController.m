//
//  DetailWebViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/16.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "DetailWebViewController.h"
#import "DetailWebModel.h"
#import "DetailImageWebModel.h"
#import "DataModel.h"
#import "DataBase.h"

@interface DetailWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DetailWebModel *detailModel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation DetailWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self prepareUI];
    [self requestData];
}

- (void)prepareUI
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 54, 44)];
    [btn setImage:[UIImage imageNamed:@"night_icon_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineV];
    
    UIButton *collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-44-10, 20, 44, 44)];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [collectBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.view addSubview:collectBtn];
    collectBtn.selected = [DataBase queryCollect:self.dataModel];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-88, 20, 44, 44)];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [shareBtn addTarget:self action:@selector(shareBtnCkick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.top = 64;
    _webView.height = SCREEN_HEIGHT - 64;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingView.frame = CGRectMake(SCREEN_WIDTH*0.5 - 20, SCREEN_HEIGHT*0.5 - 20, 40, 40);
    [self.view addSubview:_loadingView];
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.dataModel.docid];
    [[HttpRequestHelper sharedHttpRequest] getRequestUrl:url setParams:nil didFinish:^(id json, NSError *error) {
        if (error == nil) {
            weakSelf.detailModel = [DetailWebModel modelWithDictionary:json[weakSelf.dataModel.docid]];
            [weakSelf showInWebView];
        }
    }];

}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectBtnClick:(UIButton *)sender
{
    if (!sender.selected) {
        [DataBase newsCollect:self.dataModel];
    } else {
        [DataBase deleteCollect:self.dataModel];
    }
    sender.selected = !sender.selected;
}

- (void)shareBtnCkick
{
    
}

- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"Detail.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    [self.webView loadHTMLString:html baseURL:nil];
    
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailModel.ptime];
    if (self.detailModel.body != nil) {
        [body appendString:self.detailModel.body];
    }
    // 遍历img
    for (DetailImageWebModel *detailImgModel in self.detailModel.images) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject] floatValue];
        CGFloat height = [[pixel lastObject] floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

#pragma mark -UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"webViewDidFinishLoad");
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}



@end
