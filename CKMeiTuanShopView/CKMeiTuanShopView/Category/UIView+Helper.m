//
//  UIView+Helper.m
//  Qicai
//
//  Created by eims on 15/6/6.
//  Copyright (c) 2015年 7ien. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (CGFloat)getMinY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)getMidY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)getMaxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)getMinX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)getMidX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)getMaxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)getWidth {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)getHeight {
    return CGRectGetHeight(self.frame);
}

@end
