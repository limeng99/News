//
//  Photo.h
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, assign) CGFloat small_width;
@property (nonatomic, assign) CGFloat small_height;
@property (nonatomic, copy) NSString *small_url;
@property (nonatomic, copy) NSString *title;

@property (nonatomic , copy) NSString *image_url;
@property (nonatomic , assign) CGFloat image_width;
@property (nonatomic , assign) CGFloat image_height;

@end
