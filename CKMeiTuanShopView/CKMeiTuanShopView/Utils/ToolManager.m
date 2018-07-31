//
//  ToolManager.m
//  AppPark
//
//  Created by 池康 on 2017/11/22.
//

#import "ToolManager.h"
#import <CommonCrypto/CommonDigest.h>
@implementation ToolManager
/** 直接传入精度丢失有问题的Double类型*/
NSString *decimalNumberWithDouble(double conversionValue){
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (NSString *)ChineseWithInteger:(NSInteger)integer
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:(int)integer]];
    return string;
}  


+ (NSString *)returnBreakfastType:(NSString *)BreakfastType
{
    NSString *string = @"";
    //早餐：0-无早，1-双早，2-三早，3-四早，4-单早
    switch ([BreakfastType integerValue]) {
        case 0:
        {
            string = @"无早";
        }
            break;
        case 1:
        {
            string = @"双早";
        }
            break;
        case 2:
        {
            string = @"三早";
        }
            break;
        case 3:
        {
           string = @"四早";
        }
            break;
        case 4:
        {
           string = @"单早";
        }
            break;
            
        default:
            break;
    }
    return string;
}

+ (NSString *)returnCancelType:(NSString *)cancelType
{
    NSString *string = @"";
    //1-不可取消，2-限时取消，3-免费取消
    switch ([cancelType integerValue]) {
        case 1:
        {
            string = @"不可取消";
        }
            break;
        case 2:
        {
            string = @"限时取消";
        }
            break;
        case 3:
        {
            string = @"免费取消";
        }
            break;
            
        default:
            break;
    }
    return string;
}

+ (NSString *)returnRoomType:(NSString *)RoomType withTime:(NSString *)timeString
{
    
    NSString *string = @"";
    switch ([RoomType integerValue]) {
        case 1:
        {
            string = [NSString stringWithFormat:@"%@ | %@",@"公寓",timeString];
        }
            break;
        case 2:
        {
            string = [NSString stringWithFormat:@"%@ | %@",@"经济连锁",timeString];
        }
            break;
        case 3:
        {
            string = [NSString stringWithFormat:@"%@ | %@",@"其他",timeString];
        }
            break;
        case 4:
        {
            string = [NSString stringWithFormat:@"%@ | %@",@"舒适型",timeString];
        }
            break;
        case 5:
        {
            string = [NSString stringWithFormat:@"%@ | %@",@"高档型",timeString];
        }
            break;
        case 6:
        {
            string = [NSString stringWithFormat:@"%@ | %@",@"豪华型",timeString];
        }
            break;
        default:
            break;
    }
    return string;
}
//预期程度
+ (NSString *)returnYuQiType:(NSString *)YuQiType
{
    NSString *string = @"";
    if ([YuQiType floatValue] >= 4.8) {
        string = @"超出预期";
    }else if ([YuQiType floatValue]>=4.5&&[YuQiType floatValue] < 4.8){
        string = @"极好";
    }else if ([YuQiType floatValue]>=4.0&&[YuQiType floatValue] < 4.5)
    {
        string = @"不错";
    }else if ([YuQiType floatValue]>=3.0&&[YuQiType floatValue] < 4.0)
    {
       string = @"一般";
    }else if ([YuQiType floatValue]>=2.0&&[YuQiType floatValue] < 3.0)
    {
        string = @"较差";
    }else
    {
       string = @"很差";
    }
    return string;
}

+ (NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

+ (NSString *)returnTime:(NSString *)time format:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    NSString *timeString = [date stringWithFormat:format];
    return timeString;
}


//返回APP图标
+ (NSData *)returnIconImage
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* image = [UIImage imageNamed:icon];
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}


+ (UIImage *)createNonInterpolatedUIImageWithText:(NSString *)text withSize:(CGFloat) size
{
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *urlStr = text;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    UIImage *codeImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    return codeImage;
}

/**
* 根据CIImage生成指定大小的UIImage
*
* @param image CIImage
* @param size 图片宽度
*/
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark 公用方法
//通过字符串返回颜色FFFFFF
+ (UIColor *)getColor:(NSString *)colorValue andAlpha:(CGFloat)alphaValue
{
    unsigned int rf = 0, gf = 0, bf = 0;
    if ([colorValue length] == 6)
    {
        NSString *cString = [[colorValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(0,2)]] scanHexInt:&rf];
        [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(2,2)]] scanHexInt:&gf];
        [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(4,2)]] scanHexInt:&bf];
    }
    else if([colorValue length] == 8)
    {
        NSString *cString = [[colorValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(2,2)]] scanHexInt:&rf];
        [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(4,2)]] scanHexInt:&gf];
        [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(6,2)]] scanHexInt:&bf];
    }
    //DMLog(@"rf=%f  gf=%f bf=%f", rf, gf, bf);
    return [UIColor colorWithRed:rf/255.0f green:gf/255.0f blue:bf/255.0f alpha:alphaValue];
}

@end
