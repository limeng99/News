//
//  TopBannerViewController.m
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "TopBannerViewController.h"
#import "TopBannerModel.h"
#import "UIImageView+YYWebImage.h"

@interface TopBannerViewController ()<UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *currentImageV;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TopBannerViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

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
    [self setupUI];
    [self requestData];
}

- (void)setupUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = CGRectMake(5, 25, 40, 40);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"weather_back"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];

    UIButton *downbtn = [[UIButton alloc]init];
    downbtn.frame = CGRectMake(SCREEN_WIDTH - 5 - 40, backbtn.frame.origin.y, 40, 40);
    [downbtn setBackgroundImage:[UIImage imageNamed:@"arrow237"] forState:UIControlStateNormal];
    [downbtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downbtn];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.frame = CGRectMake(5, SCREEN_HEIGHT - 70 - 49, SCREEN_WIDTH - 55, 20);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [self.view addSubview:_titleLabel];
    
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+5, _titleLabel.frame.origin.y, 50, 15)];
    _countLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_countLabel];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_titleLabel.frame), SCREEN_WIDTH - 15, 60)];
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downClick
{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要保存到相册吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertV show];
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    [[HttpRequestHelper sharedHttpRequest] getRequestUrl:_url setParams:nil didFinish:^(id json, NSError *error) {
        if (error == nil) {
            NSString *titleName = json[@"setname"];
            for (NSDictionary *dic in json[@"photos"]) {
                TopBannerModel *model = [TopBannerModel modelWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf setTitleName:titleName];
            [weakSelf setImageViews];
        }
    }];
}

- (void)setTitleName:(NSString *)title
{
    self.titleLabel.text = title;
    if (self.dataArray.count > 1) {
        self.countLabel.text = [NSString stringWithFormat:@"1/%ld",self.dataArray.count];
    }
    [self setContentWithIndex:0];
}

- (void)setContentWithIndex:(NSInteger)index
{
    TopBannerModel *model = self.dataArray[index];
    if (model.note.length != 0) {
        self.textView.text = model.note;
    }else{
        self.textView.text = model.imgtitle;
    }
}

- (void)setImageViews
{
    NSInteger count = self.dataArray.count;
    for (int i = 0; i < count; i++) {
        TopBannerModel *model = self.dataArray[i];
        CGFloat imageH = self.scrollView.frame.size.height - 100;
        CGFloat imageW = self.scrollView.frame.size.width;
        CGFloat imageY = 0;
        CGFloat imageX = i * imageW;
        
        UIImageView *imaV = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [imaV setImageWithURL:[NSURL URLWithString:model.imgurl] placeholder:nil];
        imaV.contentMode= UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imaV];
    }
    
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * count, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSString *countNum = [NSString stringWithFormat:@"%d/%ld",index+1,self.dataArray.count];
    self.countLabel.text = countNum;
    if (self.dataArray.count) {
        [self setContentWithIndex:index];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImageWriteToSavedPhotosAlbum(self.currentImageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        [MBProgressHUD showError:@"下载失败"];
    }else{
        [MBProgressHUD showSuccess:@"保存成功"];
    }
}


@end
