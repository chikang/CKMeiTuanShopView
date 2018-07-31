//
//  UIImage+BlurImage.m
//  weather
//
//  Created by ibokan on 14-10-31.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UIImage+BlurImage.h"
#import <Accelerate/Accelerate.h>


@implementation UIImage (BlurImage)
/**
 *  产生模糊图片
 *
 *  @param radius     模糊半径
 *  @param iterations 迭代次数
 *  @param tintColor  前景色
 *
 *  @return 图片
 */
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = radius * self.scale;
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    CFIndex bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                         NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}


//改变图片的透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//根据颜色生成图片
+(UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame
{
    aFrame = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//修改图片的大小
+(UIImage*) changeSizeByOriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
/**
 *  保存图片在沙盒，仅仅支持PNG、JPG、JPEG
 *
 *  @param image         传入的图片
 *  @param imgName       图片的命名
 *  @param imgType       图片格式
 *  @param directoryPath 图片存放的路径
 */
+(void)saveImg:(UIImage *)image withImageName:(NSString *)imgName imgType:(NSString *)imgType inDirectory:(NSString *)directoryPath
{
    if ([[imgType lowercaseString] isEqualToString:@"png"]) {
        NSString *path = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imgName,imgType]];
        //返回一个PNG图片
        [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    }else if ([[imgType lowercaseString] isEqualToString:@"jpg"]
              || [[imgType lowercaseString] isEqualToString:@"jpeg"])
    {
        NSString *path = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imgName,imgType]];
        //第二个参数压缩质量（0最大的压缩  1最小的压缩质量）
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
    }
    else
    {
        NSLog(@"不支持该图片格式");
    }
}
/**
 *  获取图片上指定点上的颜色
 *
 *  @param point 图片上的一点
 *
 *  @return 颜色
 */
-(UIColor *)getImageColorOnPoint:(CGPoint) point
{
    CFDataRef bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    //UInt8实际就是unsigned char
    const UInt8 *data = CFDataGetBytePtr(bitmapData);
    //图片的宽度乘以点的y值得到所在的行的位置，再加上点x值即可得到该点的颜色，
    //两者都乘以4的原因是每一个像素点都占据了四个字节的长度，依次序分别是RGBA，即红色、绿色、蓝色值和透明度值。
     int index=4*self.size.width*point.y+4*point.x;
    UIColor *color = [UIColor colorWithRed:data[index]/255.0 green:data[index+1]/255.0 blue:data[index+2]/255.0 alpha:data[index+3]/255.0];
    for (int i = 0; i < 4; i++) {
        NSLog(@"%d",data[index+i]);
    }
    CFRelease(bitmapData);
    return color;
}
/**
 *  绘制一张图片，图片是由一个圆环包着的，
 *
 *  @param color   圆环的颜色
 *  @param imgSize 图片的size
 *
 *  @return 图片
 */
-(UIImage *)drawCircularIconWithColor:(UIColor *)color sizeOfImg:(CGSize)imgSize
{
    CGFloat lineWidth = 4;
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 1.0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //绘制颜色 和 圆形
    CGContextAddArc(currentContext, imgSize.width*0.5, imgSize.height*0.5, imgSize.width*0.5 - lineWidth, 0, M_PI*2, 1);
    [color set];
    CGContextSetLineWidth(currentContext, lineWidth);
    CGContextStrokePath(currentContext);
    //将图片绘制进去
    CGFloat imageW = imgSize.width;
    CGFloat imageH = imgSize.height;
    CGFloat imageX = (imgSize.width * 0.5 - imageW*0.5); //从中心点出发计算其坐标
    CGFloat imageY = (imgSize.height * 0.5 - imageH*0.5);
    [self drawInRect:CGRectMake(imageX, imageY, imageW, imageH)];
    
    UIImage *returnImg = UIGraphicsGetImageFromCurrentImageContext();
    //从上下文
    UIGraphicsEndImageContext();
    
    return returnImg;
}

/**
 绘制带有圆弧的图片
 */
- (UIImage *)drawCircularIconWithSize:(CGSize )imgSize withRadius:(CGFloat)radius
{
    //    //开启上下文
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0.0);
    //    //获取绘制圆的半径，宽，高的一个区域
    CGFloat width = imgSize.width;
    CGFloat height = width;
    CGRect rect = CGRectMake(0, 0, width, height);
//    //使用UIBerierPath路径裁切，注意：先设置裁切路径，再绘制图像。
    UIBezierPath *berzierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    //添加到裁切路径
    [berzierPath addClip];
//    //将图片绘制到裁切好的区域内
    [self drawInRect:rect];
//    //从上下文获取当前 绘制成圆形的图片
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
//    //关闭上下文
    UIGraphicsEndImageContext();
    
//    //开启上下文
//    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 1.0);
//    //获取上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //添加一个圆
//    CGFloat width = imgSize.width;
//    CGFloat height = width;
//    CGRect rect = CGRectMake(0, 0, width, height);
//    CGContextAddEllipseInRect(ctx, rect);
//    //裁剪
//    CGContextClip(ctx);
//    //将图片绘制到裁切好的区域内
//    [self drawInRect:rect];
//    //从上下文获取当前 绘制成圆形的图片
//    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
//    //关闭上下文
//    UIGraphicsEndImageContext();
    
    return resImage;
}



/**
 *  返回一张图片中颜色最多的那种颜色
 *
 *  @return color
 */
-(UIColor*)getMostColor
{
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
	CGContextDrawImage(context, drawRect, self.CGImage);
	CGColorSpaceRelease(colorSpace);
    
	
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
	if (data == NULL)
    {
        CFRelease(context);
        return nil;
    }
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
//            int offset = 4*(x + (thumbSize.width * y));
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            //将透明度小于0.1的过滤掉
            
            if (alpha < 20) {
                continue;
            }
            //过滤白色
            if (red > 230 && green > 230 && blue > 230) {
                continue;
            }
            //过滤黑色
            if (red < 30 && green < 30 && blue < 30) {
                continue;
            }
             [cls addObject:clr];
        }
    }
    CGContextRelease(context);
    
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
	NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
	while ( (curColor = [enumerator nextObject]) != nil )
	{
		NSUInteger tmpCount = [cls countForObject:curColor];
        
		if ( tmpCount < MaxCount ) continue;
		
        MaxCount=tmpCount;
        MaxColor=curColor;
        
	}
    
//    NSLog(@"The Color is %@  repeats %d",[MaxColor description],MaxCount);
	return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

/**
 *  根据图片绘制一张带圆环的图片
 *
 *  @param size 绘制之后图片的大小
 *
 *  @return 图片
 */
-(UIImage *)headerWithTorusBySzie:(CGSize)size
{
    //头像圆环的宽度
     CGFloat lineWidth =5;
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    CGContextRef currentCG = UIGraphicsGetCurrentContext();
    //画出裁剪范围 为圆形
    CGContextSetLineWidth(currentCG, lineWidth);
    CGContextAddArc(currentCG, size.width*0.5, size.width*0.5, size.width*0.5 - lineWidth, 0, M_PI *2, 0);
    CGContextClip(currentCG);

    //绘入图片
    UIImage *thisImg = [UIImage changeSizeByOriginImage:self scaleToSize:size];
    [thisImg drawAsPatternInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //绘入圆环
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7] set];
    CGContextAddArc(currentCG, size.width*0.5, size.width*0.5, size.width*0.5 - lineWidth, 0, M_PI *2, 0);
     CGContextStrokePath(currentCG);
    //保存图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   
    UIGraphicsEndImageContext();
    return image;
}


@end
