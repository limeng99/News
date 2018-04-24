//
//  PullDownCell.h
//  News
//
//  Created by 李萌萌 on 2018/4/11.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PullDownItem;

@interface PullDownCell : UICollectionViewCell

@property (nonatomic, strong) PullDownItem *item;

+ (instancetype)itemCellWithCollection:(UICollectionView *)collectionV indexPath:(NSIndexPath *)indexPath;

@end
