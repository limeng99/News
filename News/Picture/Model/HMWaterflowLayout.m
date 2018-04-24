//
//  HMWaterflowLayout.m
//  News
//
//  Created by 李萌萌 on 2018/4/12.
//  Copyright © 2018年 李萌萌. All rights reserved.
//

#import "HMWaterflowLayout.h"

NSString *const HM_UICollectionElementKindSectionHeader = @"HM_HeadView";
NSString *const HM_UICollectionElementKindSectionFooter = @"HM_FootView";

@interface HMWaterflowLayout()

//保存cell的布局
@property (nonatomic, strong) NSMutableDictionary *cellLayoutInfo;
//保存头视图的布局
@property (nonatomic, strong) NSMutableDictionary *headLayoutInfo;
//保存尾视图的布局
@property (nonatomic, strong) NSMutableDictionary *footLayoutInfo;
//记录开始的Y
@property (nonatomic, assign) CGFloat startY;
//记录瀑布流每列最下面那个cell的底部y值
@property (nonatomic, strong) NSMutableDictionary *maxYForColumn;
//记录需要添加动画的NSIndexPath
@property (nonatomic, strong) NSMutableArray *shouldanimationArr;

@end

@implementation HMWaterflowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.numberOfColumns = 3;
        self.topAndBottomDustance = 10;
        self.cellDistance = 10;
        self.headerViewHeight = 0;
        self.footViewHeight = 0;
        self.startY = 0;
        self.maxYForColumn = [NSMutableDictionary dictionary];
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
        self.headLayoutInfo = [NSMutableDictionary dictionary];
        self.footLayoutInfo = [NSMutableDictionary dictionary];
        self.shouldanimationArr = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 重新布局需要清空
    [self.cellLayoutInfo removeAllObjects];
    [self.headLayoutInfo removeAllObjects];
    [self.footLayoutInfo removeAllObjects];
    [self.maxYForColumn removeAllObjects];
    self.startY = 0;
    
    CGFloat viewWidth = self.collectionView.frame.size.width;
    // 代理里面支取高度，所以cell的宽度由列数和cell的间距计算出来
    CGFloat itemWidth = (viewWidth - self.cellDistance*(self.numberOfColumns - 1))/self.numberOfColumns;
    // 取有多少个section
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionsCount; section++) {
        //存储headerView属性
        NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        //头视图的高度不为0并且根据代理方法能取到对应的头视图的时候，添加对应头视图的布局对象
        if (_headerViewHeight > 0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HM_UICollectionElementKindSectionHeader withIndexPath:supplementaryViewIndexPath];
            // 设置frame
            attribute.frame = CGRectMake(0, self.startY, viewWidth, _headerViewHeight);
            // 保存布局对象
            self.headLayoutInfo[supplementaryViewIndexPath] = attribute;
            // 设置下一个布局对象的开始Y值
            self.startY += self.startY + _headerViewHeight + _topAndBottomDustance;
        } else {
            // 没有头视图，也要设置section的第一排cell到顶部的距离
            self.startY += _topAndBottomDustance;
        }
        
        // 将Section第一排cell的frame的Y值进行设置
        for (int i = 0; i < _numberOfColumns; i++) {
            self.maxYForColumn[@(i)] = @(self.startY);
        }
        
        // 计算cell的布局
        // 取出section有多少个row
        NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
        // 分别计算设置每个cell的布局对象
        for (NSInteger row = 0; row < rowsCount; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attribute =  [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
            // 计算当前cell加载到那一列 (瀑布流是加载到最短的一列)
            CGFloat y = [self.maxYForColumn[@(0)] floatValue];
            NSInteger currentRow = 0;
            for (int i = 1; i < _numberOfColumns; i++) {
                if ([self.maxYForColumn[@(i)] floatValue] < y) {
                    y = [self.maxYForColumn[@(i)] floatValue];
                    currentRow = i;
                }
            }
            // 计算x值
            CGFloat x = self.cellDistance + (self.cellDistance + itemWidth)*currentRow;
            // 根据代理去当前cell的高度 因为当前是采用通过列数计算的宽度，高度根据图片的原始宽高比进行设置
            CGFloat height = [(id<HMWaterflowLayoutDelegate>)self.delegate collectionView:self.collectionView layout:self heightOfItemIndexPath:cellIndexPath itemWidth:itemWidth];
            // 设置当前cell布局对象的frame
            attribute.frame = CGRectMake(x, y, itemWidth, height);
            // 重新设置当前列的Y值
            y = y + self.cellDistance + height;
            self.maxYForColumn[@(currentRow)] = @(y);
            // 保留cell的布局对象
            self.cellLayoutInfo[cellIndexPath] = attribute;
            
            // 当是section的最后一个cell时，取出最后一排cell的底部Y值 设置startY 决定下一个视图对象的起始Y值
            if (row == rowsCount - 1) {
                CGFloat maxY = [self.maxYForColumn[@(0)] floatValue];
                for (int i = 1; i < _numberOfColumns; i++) {
                    if ([self.maxYForColumn[@(i)] floatValue] > maxY) {
                        maxY = [self.maxYForColumn[@(i)] floatValue];
                    }
                }
                self.startY = maxY - self.cellDistance + self.topAndBottomDustance;
            }
        }
        
        // 存储footView的属性
        if (_footViewHeight > 0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]){
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HM_UICollectionElementKindSectionFooter withIndexPath:supplementaryViewIndexPath];
            attribute.frame = CGRectMake(0, self.startY, viewWidth, _footViewHeight);
            self.footLayoutInfo[supplementaryViewIndexPath] = attribute;
            self.startY = self.startY + _footViewHeight;
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    // 添加当前屏幕可见cell的布局
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    // 添加当前屏幕可见的头视图的布局
    [self.headLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    // 添加当前屏幕可见的尾视图的布局
    [self.footLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    return allAttributes;
}

// 插入cell的时候系统会调用该方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = self.cellLayoutInfo[indexPath];
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([elementKind isEqualToString:HM_UICollectionElementKindSectionHeader]) {
        attribute = self.headLayoutInfo[indexPath];
    } else if ([elementKind isEqualToString:HM_UICollectionElementKindSectionFooter]) {
        attribute = self.footLayoutInfo[indexPath];
    }
    return attribute;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, MAX(self.startY, self.collectionView.frame.size.height));
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
//                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
//                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                break;
        }
    }
    self.shouldanimationArr = indexPaths;
}

// 对应UICollectionViewUpdateItem 的indexPathBeforeUpdate 设置调用
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([self.shouldanimationArr containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attr = self.cellLayoutInfo[itemIndexPath];
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(2, 2), 0);
        attr.alpha = 0;
        [self.shouldanimationArr removeObject:itemIndexPath];
        return attr;
    }
    return nil;
}

- (void)finalizeCollectionViewUpdates
{
    self.shouldanimationArr = nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

// 移动相关
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition
{
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
    if([self.delegate respondsToSelector:@selector(moveItemAtIndexPath: toIndexPath:)]){
        [self.delegate moveItemAtIndexPath:previousIndexPaths[0] toIndexPath:targetIndexPaths[0]];
    }
    return context;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled
{
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:indexPaths previousIndexPaths:previousIndexPaths movementCancelled:movementCancelled];
    if(!movementCancelled){
        
    }
    return context;
}

@end
