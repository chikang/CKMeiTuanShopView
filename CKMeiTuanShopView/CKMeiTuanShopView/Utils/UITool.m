//
//  UITool.m
//  WuXianJi
//
//  Created by md003 on 15-10-31.
//  Copyright (c) 2015年 emis. All rights reserved.
//

#import "UITool.h"

typedef void(^leftButtonAction)(UIButton *button);
typedef void(^rightButtonAction)(UIButton *button);


@implementation UITool
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                          backgroundColor:(UIColor *)backgroundColor
                              placeholder:(NSString *)placeholder
                                      tag:(int)tag

{
    UITextField *textField = [[UITextField alloc]init];
    
    textField.tag                  = tag;
    textField.frame                = frame;
    textField.placeholder          = placeholder;
    textField.borderStyle          = UITextBorderStyleNone;
    textField.backgroundColor      = backgroundColor;
    textField.clearsOnBeginEditing = NO;
    
    return textField;
}


//label封装
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                  backgroundColor:(UIColor *)backgroundColor
                        textColor:(UIColor *)textColor

{
    UILabel *label = [[UILabel alloc]init];
    //创建对象
    label.frame = frame;
    //设置多行显示
//    label.numberOfLines = 1;
    //设置字体颜色
    label.textColor = textColor;
    //开启字体高亮
    label.highlighted = YES;
    //开启字体大小自动缩放
    //    label.adjustsFontSizeToFitWidth=YES;
    //设置颜色
    label.backgroundColor = backgroundColor;
    //对齐方式,默认左对齐
    label.textAlignment = NSTextAlignmentLeft;
    //把label返回给对象
    return label;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                  backgroundColor:(UIColor *)backgroundColor
                        textColor:(UIColor *)textColor
                         textSize:(CGFloat)size
                        alignment:(NSTextAlignment)alignment
                            lines:(NSInteger)lines

{
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.textColor = textColor;
    //开启字体大小自动缩放
    //label.adjustsFontSizeToFitWidth=YES;
    label.backgroundColor = backgroundColor;
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = alignment;
    label.numberOfLines = lines;
    return label;
}


+ (UILabel *)createLabelWithTextColor:(UIColor *)textColor
                         textSize:(CGFloat)size
                        alignment:(NSTextAlignment)alignment

{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = alignment;
    return label;
}


+ (id)lineLabWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = kColor_borderColor;
    return label;
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame
                                UIImage :(NSString *)image
                           cornerRadius :(int)cornerRadius


{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imageView.frame               = frame;
    //图片切成圆角
    imageView.layer.cornerRadius  = cornerRadius;
    //遮罩后面的图片
    imageView.layer.masksToBounds = YES;
    //加入视图里面
    imageView.contentMode         = UIViewContentModeScaleAspectFit;
    
    
    return imageView;
    
}

/**
 * 封装方法
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                    backgroundColor:(UIColor *)backgroundColor
                         titleColor:(UIColor *)titleColor
                             target:(id)target
                           selector:(SEL)selector
                                tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.tag                = tag;
    button.frame              = frame;
    
    [button setBackgroundImage:[AppMethods createImageWithColor:backgroundColor] forState:UIControlStateNormal];
    
    button.layer.borderWidth  = 0;
    button.layer.cornerRadius = 0;
    button.layer.masksToBounds = YES;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIScrollView *)createScrollViewWithFrame:(CGRect)frame
                                contentSize:(CGSize)contentSize
                                    bounces:(BOOL)bounces

{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    
    scrollView.frame = frame;
    scrollView.bounces = bounces;//是否可以拖到边缘
    scrollView.contentSize = contentSize;
    scrollView.pagingEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;//是否隐藏进度条
    scrollView.showsVerticalScrollIndicator = NO; //
    
    return scrollView;
}


+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                          backgroundColor:(UIColor *)backgroundColor
                              placeholder:(NSString *)placeholder
                                      tag:(int)tag
                                textColor:(UIColor *)textColor
                                leftImage:(UIImage *)image
{
    UITextField *textField = [[UITextField alloc]init];
    textField.leftViewMode         = UITextFieldViewModeAlways;
    textField.tag                  = tag;
    textField.frame                = frame;
    textField.placeholder          = placeholder;
    textField.borderStyle          = UITextBorderStyleNone;
    textField.backgroundColor      = backgroundColor;
    textField.clearsOnBeginEditing = NO;
    textField.textColor            = textColor;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, frame.size.height)];
//    backView.backgroundColor = [UIColor lightGrayColor];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 39, 39)];
    iv.image = image;
    [backView addSubview:iv];
    textField.leftView = backView;
    return textField;
}

#pragma mark  -----上拉和下拉刷新
//+ (MJRefreshGifHeader *)addBaseMJRefreshGifHeader:(httpRequest )request
//{
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        request();
//    }];
//    NSArray *idleImages = @[[UIImage imageNamed:@"loading1"],[UIImage imageNamed:@"loading2"],[UIImage imageNamed:@"loading3"],[UIImage imageNamed:@"loading4"],[UIImage imageNamed:@"loading5"],[UIImage imageNamed:@"loading6"],[UIImage imageNamed:@"loading7"],[UIImage imageNamed:@"loading8"],[UIImage imageNamed:@"loading9"],[UIImage imageNamed:@"loading10"]];
//    // 设置普通状态的动画图片
//    [header setImages:idleImages forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [header setImages:idleImages forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [header setImages:idleImages forState:MJRefreshStateRefreshing];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 隐藏状态
//    header.stateLabel.hidden = YES;
//
//    return header;
//}
//+ (MJRefreshBackGifFooter *)addBaseMJRefreshGifFooter:(httpRequest )request
//{
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
//        request();
//    }];
//    NSArray *idleImages = @[[UIImage imageNamed:@"loading1"],[UIImage imageNamed:@"loading2"],[UIImage imageNamed:@"loading3"],[UIImage imageNamed:@"loading4"],[UIImage imageNamed:@"loading5"],[UIImage imageNamed:@"loading6"],[UIImage imageNamed:@"loading7"],[UIImage imageNamed:@"loading8"],[UIImage imageNamed:@"loading9"],[UIImage imageNamed:@"loading10"]];
//    [footer setImages:idleImages forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [footer setImages:idleImages forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
//    // 设置尾部
//    // 隐藏状态
//    footer.stateLabel.hidden = YES;
//
//    return footer;
//}

@end
