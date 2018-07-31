//
//  UIView+Extension.h
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 7Kir. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRadianToDegrees(radian) (radian * M_PI )/(180.0)

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat changeWidth;
@property (nonatomic, assign) CGFloat changeHeight;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

// xib 文件名字和类名字要一样
+(id) viewInstance;

// 设置阴影
- (UIView *)setShadowWithColor:(UIColor *)color size:(CGSize)size
                   borderColor:(UIColor *)borderColor;

- (UIView *)setBorderColor:(UIColor *)borderColor
                     width:(CGFloat)borderWidth;
- (UIView *) setCornerRadius:(CGFloat)cornerRadius;

- (UIView *) rotateWithAngle:(float) angle;

#pragma mark- 删除当前视图的所有子视图
- (void)removeAllSubviews;
#pragma mark- 获取当前视图的控制器
- (UIViewController*)viewController;
@end
