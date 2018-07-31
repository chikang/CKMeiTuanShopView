//
//  UILabel+Extensions.h
//  AppPark
//
//  Created by kongxin on 2018/6/28.
//

#import <UIKit/UIKit.h>

/**
 *  UILabel某一段富文本点击
 */
@protocol YBAttributeTapActionDelegate <NSObject>

@optional
/**
 *  YBAttributeTapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)yb_attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index;
@end

@interface YBAttributeModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic, assign) NSRange range;

@end


@interface UILabel (Extensions)

/**
 设置Label行首缩进

 @param length 缩进长度
 @param text 缩进文本
 @return 缩进完成字符串
 */
- (NSAttributedString *)addFirstLineHeadIndentWithIndentLength:(CGFloat)length indenText:(NSString *)text;


/**
 添加删除线

 @param text 删除线文本
 @return 添加完成的文本
 */
- (NSMutableAttributedString *)addDeletingLineWithText:(NSString *)text deletingLinecolor:(UIColor *)color;

/**
 改变一个label其中几个字的大小跟颜色
 
 @param NeedChangeString 需要改变的字符串
 @param font 大小
 @param color 颜色
 @param range 改变范围
 @return 改变后的字符串
 */
- (NSMutableAttributedString *)addAttributedStringWithNeedChangeString:(NSString *)NeedChangeString withFont:(UIFont *)font withColor:(UIColor *)color withRange:(NSRange)range;


+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font lineSpace:(CGFloat)lineSpace;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font lineSpace:(CGFloat)lineSpace groupSpace:(CGFloat)groupSpace;


/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
//- (void)yb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
//                                 tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
//- (void)yb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
//                                   delegate:(id <YBAttributeTapActionDelegate> )delegate;

@end
