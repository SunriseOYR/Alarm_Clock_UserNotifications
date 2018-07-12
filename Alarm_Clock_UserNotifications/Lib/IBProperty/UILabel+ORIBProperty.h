//
//  UILabel+ORIBProperty.h
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/8.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UILabel (ORIBProperty)

/*
 * 根据屏幕的宽度 适配 字体大小
 * adapt font size by screen width
 */
@property (nonatomic, assign) IBInspectable BOOL ib_adaptFont;

/*
 * 给文字添加 下划线
 * add a underline for text
 */
@property (nonatomic, assign) IBInspectable BOOL ib_underLine;

/*
 * 给文字添加中间横线
 * add a middleLine for text
 */
@property (nonatomic, assign) IBInspectable BOOL ib_middleLine;



@end
