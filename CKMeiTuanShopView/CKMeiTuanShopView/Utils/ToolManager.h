//
//  ToolManager.h
//  AppPark
//
//  Created by 池康 on 2017/11/22.
//

#import <Foundation/Foundation.h>

@interface ToolManager : NSObject


//小写数字转汉字大写
+ (NSString *)ChineseWithInteger:(NSInteger)integer;

+ (NSString *)returnBreakfastType:(NSString *)BreakfastType;

+ (NSString *)returnCancelType:(NSString *)cancelType;

//豪华程度
+ (NSString *)returnRoomType:(NSString *)RoomType  withTime:(NSString *)timeString;
//预期程度
+ (NSString *)returnYuQiType:(NSString *)YuQiType;


//URL  解码
+ (NSString *)URLDecodedString:(NSString *)str;

//返回具体的时间
+ (NSString *)returnTime:(NSString *)time format:(NSString *)format;

//返回APP图标
+ (NSData *)returnIconImage;


//生成高清二维码图片
+ (UIImage *)createNonInterpolatedUIImageWithText:(NSString *)text withSize:(CGFloat) size;

#pragma mark 公用方法
//通过字符串返回颜色FFFFFF
+ (UIColor *)getColor:(NSString *)colorValue andAlpha:(CGFloat)alphaValue;
@end
