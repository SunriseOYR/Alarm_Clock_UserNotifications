//
//  UIControl+ORIBProperty.m
//  IBPropertyDemo
//
//  Created by OrangesAL on 2018/1/24.
//  Copyright © 2018年 OrangesAL. All rights reserved.
//

#import "UIControl+ORIBProperty.h"
#import "ORIBProperty.h"

@implementation UIControl (ORIBProperty)

- (void)setIb_reClickEnabled:(BOOL)ib_reClickEnabled {
    
    if (ib_reClickEnabled == YES) {
        [self aspect_hookSelector:@selector(sendAction:to:forEvent:) withOptions:AspectPositionAfter usingBlock:^(){
            self.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.enabled = YES;
            });
        } error:nil];
    }
}

- (BOOL)ib_reClickEnabled {
    return NO;
}

@end
