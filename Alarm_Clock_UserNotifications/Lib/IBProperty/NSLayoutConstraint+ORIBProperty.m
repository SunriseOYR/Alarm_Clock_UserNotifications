//
//  NSLayoutConstraint+ORIBProperty.m
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/9.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import "NSLayoutConstraint+ORIBProperty.h"
#import "ORIBProperty.h"

static NSString *ib_adaptXTopConstantKey = @"ib_adaptXTopConstantKey";

@implementation NSLayoutConstraint (ORIBProperty)

- (void)setIb_adaptConstant:(BOOL)ib_adaptConstant {
    
    if (ib_adaptConstant == YES && self.ib_adaptXTopConstant == NO) {
        self.constant = IB_HP(self.constant);
    }
}

- (BOOL)ib_adaptConstant {
    return NO;
}

- (void)setIb_adaptXTopConstant:(BOOL)ib_adaptXTopConstant {
    
    objc_setAssociatedObject(self, &ib_adaptXTopConstantKey, @(ib_adaptXTopConstant), OBJC_ASSOCIATION_ASSIGN);
    
    if (ib_adaptXTopConstant == YES) {
        //iPhone X
        if ([UIScreen mainScreen].bounds.size.height > 800) {
            
            if (self.firstAttribute == NSLayoutAttributeCenterY) {
                self.constant += 12;
            }else {
                self.constant += 24;
            }
        }
    }
}

- (BOOL)ib_adaptXTopConstant {
    return [objc_getAssociatedObject(self, &ib_adaptXTopConstantKey) boolValue];
}



@end
