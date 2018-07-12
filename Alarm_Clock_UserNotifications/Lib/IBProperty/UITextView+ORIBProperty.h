//
//  UITextView+ORIBProperty.h
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/13.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UITextView (ORIBProperty)

/*
 * 根据屏幕的宽度 适配 字体大小
 * adapt font size by screen width
 */
@property (nonatomic, assign) IBInspectable BOOL ib_adaptFont;

/*
 * 类似于UITextField的placeholder
 * like UITextField's placeholder
 */
@property (nonatomic, copy) IBInspectable NSString * ib_placeholder;

@end
