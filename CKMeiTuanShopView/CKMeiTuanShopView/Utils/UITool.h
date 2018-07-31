//
//  UITool.h
//
//  Created by md003 on 15-10-31.
//  Copyright (c) 2015年 emis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJRefresh.h"
//#import "CustomLabel.h"
typedef void(^naviBarsubViews)(UIImageView *iv,UIButton *leftButton,UIButton * rightButton);

typedef NS_ENUM(NSInteger,ButtonTag){
    ButtonTagLeft,
    ButtonTagRight
};

typedef void (^httpRequest)();//刷新请求

@interface UITool : NSObject

@property (nonatomic,copy)httpRequest headRequest;

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                          backgroundColor:(UIColor *)backgroundColor
                              placeholder:(NSString *)placeholder
                                      tag:(int)tag;
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                          backgroundColor:(UIColor *)backgroundColor
                              placeholder:(NSString *)placeholder
                                      tag:(int)tag
                                textColor:(UIColor *)textColor
                                leftImage:(UIImage *)image;
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                  backgroundColor:(UIColor *)backgroundColor
                        textColor:(UIColor *)textColor;


+ (UIImageView *)createImageViewWithFrame:(CGRect)frame
                                 UIImage :(NSString *)image
                            cornerRadius :(int)cornerRadius;

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                    backgroundColor:(UIColor *)backgroundColor
                         titleColor:(UIColor *)titleColor
                             target:(id)target
                           selector:(SEL)selector
                                tag:(int)tag;

+ (UIScrollView *)createScrollViewWithFrame:(CGRect)frame
                                contentSize:(CGSize)contentSize
                                    bounces:(BOOL)bounces;

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                      backgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                             textSize:(CGFloat)size
                            alignment:(NSTextAlignment)alignment
                                lines:(NSInteger)lines;

+ (UILabel *)createLabelWithTextColor:(UIColor *)textColor
                             textSize:(CGFloat)size
                            alignment:(NSTextAlignment)alignment;

+ (id)lineLabWithFrame:(CGRect)frame;

//#pragma mark  -----上拉和下拉刷新
//+ (MJRefreshGifHeader *)addBaseMJRefreshGifHeader:(httpRequest )request;
//
//+ (MJRefreshBackGifFooter *)addBaseMJRefreshGifFooter:(httpRequest )request;
@end
