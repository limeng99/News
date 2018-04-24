//
//  NSString+Extension.h
//  HouseYX
//
//  Created by limeng on 16/2/2.
//  Copyright © 2016年 limeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

// 返回字符串适合尺寸
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

 //  MD5加密
- (NSString *)md5String;

@end
