//
//  UIImageView+ORIBProperty.h
//  IBPropertyDemo
//
//  Created by OrangesAL on 2018/1/31.
//  Copyright © 2018年 OrangesAL. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIImageView (ORIBProperty)

//Effect
@property(nonatomic, assign) IBInspectable BOOL  ib_darkEffect;
@property(nonatomic, assign) IBInspectable BOOL  ib_lightEffect;

//opacity of effect 0 - 1
@property(nonatomic, assign) IBInspectable CGFloat  ib_effectOpacity;


@end
