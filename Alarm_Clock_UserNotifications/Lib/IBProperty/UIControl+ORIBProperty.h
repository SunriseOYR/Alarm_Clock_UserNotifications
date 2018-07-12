//
//  UIControl+ORIBProperty.h
//  IBPropertyDemo
//
//  Created by OrangesAL on 2018/1/24.
//  Copyright © 2018年 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIControl (ORIBProperty)

/*
 * 禁止重复点击（2秒内不能重复点击）
 * no repeated clicks in 2 seconds
 */
@property (nonatomic, assign) IBInspectable BOOL ib_reClickEnabled;

@end
