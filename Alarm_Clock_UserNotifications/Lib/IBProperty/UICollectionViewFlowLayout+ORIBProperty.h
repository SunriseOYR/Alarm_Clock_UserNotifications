//
//  UICollectionViewFlowLayout+ORIBProperty.h
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/13.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UICollectionViewFlowLayout (ORIBProperty) 

/* itemSize、minimumLineSpacing、minimumInteritemSpacing、headerReferenceSize、footerReferenceSize、sectionInset
 */
@property (nonatomic, assign) IBInspectable BOOL ib_adaptSize;


/*
 * collectionView每行显示的item的个数  将自动设置 ib_adaptSize 为YES
 * the number of items at row in collectionView, ib_adaptSize would be YES
 */
@property (nonatomic, assign) IBInspectable NSInteger ib_numberItemsForRow;

@end
