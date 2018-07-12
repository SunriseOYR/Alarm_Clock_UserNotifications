//
//  NSObject+ORIBProperty.m
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/12/15.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import "NSObject+ORIBProperty.h"
#import "ORIBProperty.h"

@interface NSObject()

@property (nonatomic, copy) void(^blcok)(void);

@end

@implementation NSObject (ORIBProperty)

- (void)ib_methodExchangeWithSelector:(SEL)selector toSelector:(SEL)toSector {
    
    Method old = class_getInstanceMethod([self class], selector);
    Method new = class_getInstanceMethod([self class], toSector);
    
    if ([[self class] instancesRespondToSelector:toSector]) {
        method_exchangeImplementations(old, new);
    }
}

- (void)ib_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ib_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

@end
