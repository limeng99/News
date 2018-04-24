//
//  HMWaterflowLayout.h
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const HM_UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const HM_UICollectionElementKindSectionFooter;

@class HMWaterflowLayout;
@protocol HMWaterflowLayoutDelegate <NSObject>

// 代理取cell的高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HMWaterflowLayout *)layout heightOfItemIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional
// 处理移动相关的数据源
- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@interface HMWaterflowLayout : UICollectionViewLayout

//瀑布流有列
@property (assign, nonatomic) NSInteger numberOfColumns;
//cell之间的间距
@property (assign, nonatomic) CGFloat cellDistance;
//cell 到顶部 底部的间距
@property (assign, nonatomic) CGFloat topAndBottomDustance;
//头视图的高度
@property (assign, nonatomic) CGFloat headerViewHeight;
//尾视图的高度
@property (assign, nonatomic) CGFloat footViewHeight;

@property (nonatomic, weak) id<HMWaterflowLayoutDelegate> delegate;



@end
