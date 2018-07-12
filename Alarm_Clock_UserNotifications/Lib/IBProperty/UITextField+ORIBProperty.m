//
//  UITextField+ORIBProperty.m
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/13.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import "UITextField+ORIBProperty.h"
#import "ORIBProperty.h"

@implementation UITextField (ORIBProperty)

- (void)setIb_adaptFont:(BOOL)ib_adaptFont {
    
    if (ib_adaptFont == YES) {
        self.font = ib_fontAdaptWithFont(self.font);
    }
}

- (BOOL)ib_adaptFont {
    return NO;
}


@end
