//
//  PhotoCell.h
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) Photo *photo;

+ (instancetype)itemCellWithCollection:(UICollectionView *)collectionV indexPath:(NSIndexPath *)indexPath;

@end
