//
//  UITextView+ORIBProperty.m
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/13.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import "UITextView+ORIBProperty.h"
#import "ORIBProperty.h"

static NSInteger const placeholderTag = 2017;

@implementation UITextView (ORIBProperty)

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setIb_adaptFont:(BOOL)ib_adaptFont {
    
    if (ib_adaptFont == YES) {
        self.font = ib_fontAdaptWithFont(self.font);
    }
}

- (BOOL)ib_adaptFont {
    return NO;
}

- (void)setIb_placeholder:(NSString *)ib_placeholder {
    if (ib_placeholder.length > 0) {
        UILabel *label = [self viewWithTag:placeholderTag];
        if (!label) {
            label = [UILabel new];
            label.font = self.font;
            label.textColor = [UIColor colorWithRed:213/255.f green:213/255.f blue:213/255.f alpha:1];
            label.tag = placeholderTag;
            [self frameChangedWith:label];
            label.numberOfLines = 0;
            [self addSubview:label];
        }
        label.text = ib_placeholder;
        [label sizeToFit];
        label.hidden = self.text.length > 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginEditing) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEndEditing) name:UITextViewTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];

        __weak typeof (self) weakSelf = self;

        [self aspect_hookSelector:@selector(setBounds:) withOptions:AspectPositionAfter usingBlock:^{
            [weakSelf frameChangedWith:label];
            [label sizeToFit];
        } error:nil];
        
        [self aspect_hookSelector:@selector(setText:) withOptions:AspectPositionAfter usingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.ib_plceholderLabel.hidden = strongSelf.text.length > 0 || [strongSelf isFirstResponder];
        } error:nil];
        
        [self aspect_hookSelector:@selector(setTextContainerInset:) withOptions:AspectPositionAfter usingBlock:^{
            [weakSelf frameChangedWith:label];
            [label sizeToFit];
        } error:nil];
        
        [self aspect_hookSelector:@selector(setFont:) withOptions:AspectPositionAfter usingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.ib_plceholderLabel.font = strongSelf.font;
        } error:nil];
    }
}

- (void)frameChangedWith:(UILabel *)label {
    label.frame = CGRectMake(self.textContainerInset.left + 5, self.textContainerInset.top, self.bounds.size.width - (self.textContainerInset.left + self.textContainerInset.right), self.bounds.size.height - (self.textContainerInset.top + self.textContainerInset.bottom));
}

- (NSString *)ib_placeholder {
    return self.ib_plceholderLabel.text;
}

- (void)textBeginEditing {
    self.ib_plceholderLabel.hidden = YES;
}

- (void)textEndEditing {
    self.ib_plceholderLabel.hidden = self.text.length > 0;
}

- (void)textDidChange {
    self.ib_plceholderLabel.hidden = self.text.length > 0 || [self isFirstResponder];
}

- (UILabel *)ib_plceholderLabel {
    return [self viewWithTag:placeholderTag];
}

@end

