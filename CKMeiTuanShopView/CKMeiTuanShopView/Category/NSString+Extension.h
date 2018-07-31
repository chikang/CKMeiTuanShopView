//
//  NSString+Extension.h
//  汇银
//
//  Created by 李小斌 on 14-11-27.
//  Copyright (c) 2014年 7ien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+(NSString *) priceWithSign:(CGFloat)value;

+(NSString *) priceWithoutSign:(CGFloat)value;

+(NSString *)stringUtils:(id)stringValue;

+(NSString *)jsonUtils:(id)stringValue;

+(NSString *)jsonUtils22:(id)stringValue;

/*
 * 判断字符串是否为空白的
 */
- (BOOL)isBlank;

/*
 * 判断字符串是否为空
 */
- (BOOL)isEmpty;

+ (BOOL)isEmpty:(id)stringValue;

- (BOOL)isNULL;

// 把手机号第4-7位变成星号
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum;

// 把邮箱@前面变成星号
+(NSString*)emailToAsterisk:(NSString *)email;

// 把身份证号第5-14位变成星号
+(NSString *)idCardToAsterisk:(NSString *)idCardNum;

// 判断是否是身份证号码
+(BOOL)validateIdCard:(NSString *)idCard;

// 邮箱验证
+(BOOL)validateEmail:(NSString *)email;

//判断字符串中是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

//    Vindor标示符 (IDFV-identifierForVendor)
+ (NSString *)returnIdfv;

// 手机号码验证
+(BOOL)validateMobile:(NSString *)mobile;

//固话验证
+ (BOOL) validateAreaTel:(NSString *)areaTel;

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)firstCharactor:(NSString *)aString;

//将URL内的中文进行编码
+ (NSString *)URLEncodedString:(NSString *)urlString;

//字典转换成字符串
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

//字符串转成字典
+ (NSDictionary *)dicWithString:(NSString *)string;

//数组转换成字符串
+(NSString *) jsonStringWithArray:(NSArray *)array;

//json字符串转换成普通字符串
//+(NSString *) jsonStringWithString:(NSString *) string;

//json对象转换成字符串
+(NSString *) jsonStringWithObject:(id) object;

//重写containsString方法，兼容8.0以下版本
- (BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0);

//通过文本宽度计算高度
-(CGSize) calculateSize:(UIFont *)font maxWidth:(CGFloat)width;

/*获取网络流量信息*/
+ (long long) getInterfaceBytes;
/**过滤表情*/
+ (NSString *)disable_emoji:(NSString *)text;

/**获取缓存大小*/
+ (NSString *)getCacheSize;

//根据正则，过滤特殊字符
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr;

//有效数字
- (BOOL)yw_isValidateDecimalsNum;\
/// 获取字符串宽高
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 设置行间距
 
 @param label 需要设置行间距的label
 @param textStr 需要设置行间距的文本
 @param font 字体大小
 @param lineSpacing 间距
 */
+(void)setLabelSpaceWithLabel:(UILabel*)label withTextStr:(NSString*)textStr withFont:(UIFont*)font withLineSpacing:(NSInteger)lineSpacing;

/**
 计算UILabel的高度(带有行间距的情况跟上面设置行间距方法同时使用才有效)
 
 @param textStr label的文本
 @param font 字体
 @param width 文本宽度
 @param lineSpacing 有行间距的label传入实际行间距 没有默认为0
 @return label实际的高度
 */
+(CGFloat)getSpaceLabelHeightWithText:(NSString*)textStr withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpacing:(NSInteger)lineSpacing;


@end
