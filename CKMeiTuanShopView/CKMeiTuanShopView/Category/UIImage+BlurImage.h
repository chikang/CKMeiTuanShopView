//
//  UIImage+BlurImage.h
//  weather
//
//  Created by ibokan on 14-10-31.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurImage)

/**
 *  产生模糊图片
 *
 *  @param radius     模糊半径
 *  @param iterations 迭代次数
 *  @param tintColor  前景色
 *
 *  @return 图片
 */
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
/**
   修改传入图片的透明度
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;
/**
   根据颜色和尺寸生成一张图片
 */
+(UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame;
/**
   修改传入图片的尺寸
 */
+(UIImage*) changeSizeByOriginImage:(UIImage *)image scaleToSize:(CGSize)size;
/**
 *  保存图片在沙盒，仅仅支持PNG、JPG、JPEG
 *
 *  @param image         传入的图片
 *  @param imgName       图片的命名
 *  @param imgType       图片格式
 *  @param directoryPath 图片存放的路径
 */
+(void)saveImg:(UIImage *)image withImageName:(NSString *)imgName imgType:(NSString *)imgType inDirectory:(NSString *)directoryPath;
/**
 *  获取图片上指定点上的颜色
 *
 *  @param point 图片上的一点
 *
 *  @return 颜色
 */
-(UIColor *)getImageColorOnPoint:(CGPoint) point;
/**
 *  绘制一张图片，图片是由一个圆环包着的，
 *
 *  @param color   圆环的颜色
 *  @param imgSize 图片的size
 *
 *  @return 图片
 */
-(UIImage *)drawCircularIconWithColor:(UIColor *)color sizeOfImg:(CGSize)imgSize;
/**
 *  返回一张图片中颜色最多的那种颜色
 *
 *  @return color
 */
-(UIColor*)getMostColor;
/**
 *  根据图片绘制一张带圆环的图片
 *
 *  @param size 绘制之后图片的大小
 *
 *  @return 图片
 */
-(UIImage *)headerWithTorusBySzie:(CGSize)size;

/**
 绘制带有圆弧的图片
 */
- (UIImage *)drawCircularIconWithSize:(CGSize )imgSize withRadius:(CGFloat)radius;
@end
