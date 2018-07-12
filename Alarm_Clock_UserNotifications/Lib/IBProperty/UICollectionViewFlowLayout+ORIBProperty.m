//
//  UICollectionViewFlowLayout+ORIBProperty.m
//  BaidiLuxury
//
//  Created by OrangesAL on 2017/11/13.
//  Copyright © 2017年 OrangesAL. All rights reserved.
//

#import "UICollectionViewFlowLayout+ORIBProperty.h"
#import "ORIBProperty.h"

static const NSString *ib_numberItemsForRowKey = @"ib_numberItemsForRowKey";
static const NSString *ib_adaptSizeKey = @"ib_adaptSizeKey";

@implementation UICollectionViewFlowLayout (ORIBProperty)

- (void)setIb_adaptSize:(BOOL)ib_adaptSize {
    
    if (ib_adaptSize == YES) {
        
        if (self.ib_adaptSize == YES && self.ib_numberItemsForRow > 0) {
            [self itemSizeAdapt];
        }else {
            self.minimumLineSpacing = IB_HP(self.minimumLineSpacing);
            self.minimumInteritemSpacing = IB_HP(self.minimumInteritemSpacing);
            
            self.headerReferenceSize = CGSizeMake(IB_HP(self.headerReferenceSize.width), IB_HP(self.headerReferenceSize.height));
            
            self.footerReferenceSize = CGSizeMake(IB_HP(self.footerReferenceSize.width), IB_HP(self.footerReferenceSize.height));
            
            self.sectionInset = ib_insetsAdaptWithInsets(self.sectionInset);
            
            [self itemSizeAdapt];
        }
        
    }
    
    objc_setAssociatedObject(self, &ib_adaptSizeKey, @(ib_adaptSize), OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (BOOL)ib_adaptSize {
    return [objc_getAssociatedObject(self, &ib_adaptSizeKey) boolValue];
}

- (void)setIb_numberItemsForRow:(NSInteger)ib_numberItemsForRow {
    
    objc_setAssociatedObject(self, &ib_numberItemsForRowKey, @(ib_numberItemsForRow), OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.ib_adaptSize = YES;

    [self.collectionView aspect_hookSelector:@selector(setBounds:) withOptions:AspectPositionAfter usingBlock:^{
        self.ib_adaptSize = YES;
    } error:nil];
    
}

- (NSInteger)ib_numberItemsForRow {
    return [objc_getAssociatedObject(self, &ib_numberItemsForRowKey) integerValue];
}

- (void)itemSizeAdapt {
    
    if (self.ib_numberItemsForRow == 0) {
        
        self.itemSize = CGSizeMake(IB_HP(self.itemSize.width), IB_HP(self.itemSize.height));
    }else {
        CGFloat proportion = self.itemSize.width / self.itemSize.height ;
        CGFloat width = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right -(self.ib_numberItemsForRow - 1) * self.minimumInteritemSpacing) / self.ib_numberItemsForRow - 1;
        
        self.itemSize = CGSizeMake(width, width / proportion);
    }
    
}

@end
