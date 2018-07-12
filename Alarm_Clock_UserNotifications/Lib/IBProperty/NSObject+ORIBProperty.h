//
//  NSObject+ORIBProperty.h
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/12/15.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ORIBProperty)

- (void)ib_methodExchangeWithSelector:(SEL)selector toSelector:(SEL)toSector;

- (void)ib_setAssociateValue:(id)value withKey:(void *)key;

- (id)ib_getAssociatedValueForKey:(void *)key;


@end
