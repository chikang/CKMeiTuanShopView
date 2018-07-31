//
//  UIView+Extension.m
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 7Kir. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.x = top;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setChangeWidth:(CGFloat)changeWidth
{
    CGRect frame = self.frame;
    frame.size.width = changeWidth;
    self.frame = frame;
}

- (CGFloat)changeWidth
{
    return self.frame.size.width;
}

- (void)setChangeHeight:(CGFloat)changeHeight
{
    CGRect frame = self.frame;
    frame.size.height = changeHeight;
    self.frame = frame;
}

- (CGFloat)changeHeight
{
    return self.frame.size.height;
}

-(void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

-(CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

-(CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

+(id) viewInstance
{
    NSString *clazz = NSStringFromClass(self);
    NSString *path = [[NSBundle mainBundle] pathForResource:clazz ofType:@"nib"];
    if (path) {
        NSArray *tmp = [[NSBundle mainBundle] loadNibNamed:clazz owner:nil options:nil];
        UIView *view = [tmp lastObject];
        
        return view;
    }
    
    UIView *view = [[NSClassFromString(clazz) alloc] init];
    return view;
}

- (UIView *)setShadowWithColor:(UIColor *)color size:(CGSize)size borderColor:(UIColor *)borderColor
{
    self.layer.borderWidth = 0.1f;
    self.layer.shadowColor = color.CGColor;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.shadowOffset = size;
    self.layer.shadowOpacity = 0.6f;
    
    return self;
}

- (UIView *)setBorderColor:(UIColor *)borderColor
                     width:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    return self;
}

- (UIView *) setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds =YES;
    self.layer.cornerRadius = cornerRadius;
    
    return self;
}

-(UIView *) rotateWithAngle:(float) angle
{
    if (![self respondsToSelector:@selector(layer)]) {
        NSLog(@"This view(%@) don't have layer property. Can't rotate.", self);
        return self;
    }
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformRotate(self.transform, kRadianToDegrees(angle));
    }];
    
    return self;
}

#pragma mark- 删除当前视图的所有子视图
- (void)removeAllSubviews
{
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}
#pragma mark- 获取当前视图的控制器
- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
