//
//  UIImageView+ORIBProperty.m
//  IBPropertyDemo
//
//  Created by OrangesAL on 2018/1/31.
//  Copyright © 2018年 OrangesAL. All rights reserved.
//

#import "UIImageView+ORIBProperty.h"
#import "UIView+ORIBProperty.h"
#import "ORIBProperty.h"

static NSInteger const effectViewTag = 2018;

@implementation UIImageView (ORIBProperty)

- (void)setIb_lightEffect:(BOOL)ib_lightEffect {
    
    if (ib_lightEffect == YES) {
        [self addEffectWithStyle:UIBlurEffectStyleLight];
    }
}

- (BOOL)ib_lightEffect {
    return NO;
}

- (void)setIb_darkEffect:(BOOL)ib_darkEffect {
    if (ib_darkEffect == YES) {
        [self addEffectWithStyle:UIBlurEffectStyleDark];
    }
}

- (BOOL)ib_darkEffect {
    return  NO;
}

- (void)setIb_effectOpacity:(CGFloat)ib_effectOpacity {
    if (ib_effectOpacity > 0) {
        
        CGFloat alpha = ib_effectOpacity > 1 ? 1 : ib_effectOpacity;
        
        alpha = (1- alpha) * 0.4 + alpha;
        
//        NSLog(@"asda %lf", alpha);
        
        objc_setAssociatedObject(self, @selector(setIb_effectOpacity:), @(alpha), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
        UIVisualEffectView *effectView = [self viewWithTag:effectViewTag];
        effectView.alpha = alpha;
    }
}

- (CGFloat)ib_effectOpacity {
    return [objc_getAssociatedObject(self, @selector(setIb_effectOpacity:)) doubleValue];
}


#pragma mark -- private
- (void)addEffectWithStyle:(UIBlurEffectStyle)style{
    
    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:style];
    
    UIVisualEffectView *effectView = [self viewWithTag:effectViewTag];
    
    if (!effectView) {
        effectView = [self ib_creatEffectViewWithEffect:effect];
    }else {
        if (@available(iOS 9, *)) {
            effectView.effect = effect;
        }else {
            [effectView removeFromSuperview];
            effectView = [self ib_creatEffectViewWithEffect:effect];
        }
    }
}

- (UIVisualEffectView *)ib_creatEffectViewWithEffect:(UIBlurEffect *)effect {
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.bounds;
    effectView.tag = effectViewTag;
    CGFloat alpha = self.ib_effectOpacity > 0 ? self.ib_effectOpacity : 0.5;
    effectView.alpha = alpha;
    [self addSubview:effectView];
    effectView.ib_cornerRadius = self.ib_cornerRadius;
    effectView.ib_cornerCircle = self.ib_cornerCircle;

    __weak typeof (self) weakSelf = self;
    
    [self aspect_hookSelector:@selector(setIb_cornerCircle:) withOptions:AspectPositionAfter usingBlock:^{
        effectView.ib_cornerCircle = weakSelf.ib_cornerCircle;
    } error:nil];
    
    [self aspect_hookSelector:@selector(setIb_cornerRadius:) withOptions:AspectPositionAfter usingBlock:^{
        effectView.ib_cornerRadius = weakSelf.ib_cornerRadius;
    } error:nil];
    
    [self aspect_hookSelector:@selector(setBounds:) withOptions:AspectPositionAfter usingBlock:^{
        effectView.bounds = weakSelf.bounds;
        effectView.frame = weakSelf.bounds;
    } error:nil];
    
    return effectView;
}

- (UIBlurEffect *)ib_currentEffectStyle {
    
    UIVisualEffectView *effectView = [self viewWithTag:effectViewTag];
    return (UIBlurEffect *)effectView.effect;
}

@end
