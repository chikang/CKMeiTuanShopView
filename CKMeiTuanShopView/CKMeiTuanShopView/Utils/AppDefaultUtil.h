//
//  AppDefaultUtil.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-9-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AppDefaultUtil : NSObject

/**
 单例模式，实例化对象
 */
+ (instancetype)sharedInstance;


//图文混排，插入图片
+ (NSMutableAttributedString *)addAttribute:(NSString *)name withImg:(UIImage *)image withImgSize:(CGRect)bounds insertIndex:(NSInteger)index;

/**行间距*/
+(NSMutableAttributedString *)returnLineSpacingWithStr:(NSString *)labelText  withLineSpacing:(CGFloat)lineCount withTextAlignmentCenter:(NSTextAlignment )alignment;

+(NSMutableAttributedString *)returnLineSpacingWithStr22:(NSMutableAttributedString *)labelText  withLineSpacing:(CGFloat)lineCount withTextAlignmentCenter:(NSTextAlignment )alignment;

/**
  字符串两边字体的颜色设置

 @param string 字符串
 @param rang 范围
 @param color 颜色
 @return 返回富文本
 */
+ (NSMutableAttributedString *)returnStringColor:(NSString *)string rang:(NSRange)rang color:(UIColor *)color;
//字符串两边字体的大小设置
+ (NSMutableAttributedString *)returnStringSize:(NSString *)string rang:(NSRange)rang size:(CGFloat)size;


@end
