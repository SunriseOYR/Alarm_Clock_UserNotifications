//
//  NSLayoutConstraint+ORIBProperty.h
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/9.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface NSLayoutConstraint (ORIBProperty)

/*
 * 根据屏幕的宽度 适配 约束常量 constant
 * adapt constraint constant by screen width
 */
@property (nonatomic, assign) IBInspectable BOOL ib_adaptConstant;

/*
 * 适配导航栏高度，若为YES constant将不会适配比例，而是在iPhone X 上加上24pt, 常用于 为自定义导航栏的子视图添加约束
 * constant would not adapt but add 24px in iPhone X
 */
@property (nonatomic, assign) IBInspectable BOOL ib_adaptXTopConstant;

@end
