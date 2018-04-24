//
//  LocalViewController.h
//  News
//
//  Created by 李萌萌 on 2018/4/18.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "BaseViewController.h"

@interface LocalViewController : BaseViewController

@property (nonatomic, copy) void(^loclViewControllerBlock)(NSString *stateName, NSString *cityName);

@end
