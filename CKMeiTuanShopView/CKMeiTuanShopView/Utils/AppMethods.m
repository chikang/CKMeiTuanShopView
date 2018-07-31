//
//  AppMethods.m
//  exsd
//
//  Created by CK on 2017/3/1.
//  Copyright © 2017年 CK. All rights reserved.
//  集合 APP 一些公共方法

#import "AppMethods.h"

@implementation AppMethods

+ (void)printJsonData:(NSData *)jsonData
{
    DMLog(@"json Str: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}


+ (UIImage *)createImageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(20, 20));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 20, 20));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [theImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [theImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)createImageWithColor22:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(20, 30));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 20, 30));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [theImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
}



#pragma mark - 颜色相关
+ (UIColor *)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+ (UIColor *)colorWithHexString: (NSString *)color WithAlpha:(float)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

#pragma mark - 计算字符串宽高
+ (CGSize)sizeWithFont:(UIFont*)font Str:(NSString*)str withMaxWidth:(CGFloat)maxWidth
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize strSize = [str boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                       options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                    attributes:attribute
                                       context:nil].size;
    
    return strSize;
}

+ (CGSize)sizeAttributedWithFont:(UIFont*)font Str:(NSMutableAttributedString*)str withMaxWidth:(CGFloat)maxWidth
{
    CGSize strSize = [str boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    return strSize;
}


+ (NSString *)getImageDataBase64:(UIImage *)image
{
    NSData *imageData =nil;
    
    //图片要压缩的比例，此处100根据需求，自行设置
    CGFloat x =100 / image.size.height;
    if (x >1)
    {
        x = 1.0;
    }
    
    imageData = UIImageJPEGRepresentation(image, x);
    
    return [@"data:image/png;base64," stringByAppendingString:[imageData base64EncodedStringWithOptions:0]];
}

#pragma mark - 银行卡账号形式转换
// 正常号转银行卡号 － 增加4位间的空格
+ (NSString *)normalNumToBankNum:(NSString *)normalNum
{
    if (normalNum == nil || normalNum.length == 0) {
        return @"";
    }
    
    NSString *tmpStr = [AppMethods bankNumToNormalNum:normalNum];
    
    NSInteger size = (tmpStr.length / 4);
    
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    //去掉前后的空格
    if ([tmpStr hasPrefix:@" "] || [tmpStr hasSuffix:@" "] == YES)
    {
        tmpStr = [tmpStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    return tmpStr;
}

// 银行卡号转正常号 － 去除4位间的空格
+ (NSString *)bankNumToNormalNum:(NSString *)bankNum
{
    return [bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString *)bankNumToSecret:(NSString *)bankNum
{
    if (bankNum.length < 8 || bankNum == nil)
    {
        return bankNum;
    }
    NSString *star = @"";
    for (int i = 0; i < (bankNum.length-8) ; i++)
    {
        star = [star stringByAppendingString:@"*"];
    }
    
    NSString *tmpStr = [bankNum stringByReplacingCharactersInRange:NSMakeRange(4, bankNum.length-8) withString:star];
    return tmpStr;
}

#pragma mark - 通过 parentId 筛选 城市或区（县）
+ (NSArray *)filterAraeFromAreaArray:(NSArray *)areaArray useParentId:(NSInteger)parentId
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"parentId == %@", @(parentId)];
    NSArray *resultArray = [areaArray filteredArrayUsingPredicate:pred];
    return resultArray;
}

#pragma mark - 通过 parentNo 筛选 分类
+ (NSArray *)filterClassFromAreaArray:(NSArray *)areaArray useParentNo:(NSString *)parentNo
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"parentNo == %@",parentNo];
    NSArray *resultArray = [areaArray filteredArrayUsingPredicate:pred];
    return resultArray;
}

#pragma mark - 限制只能输入数字输入
+ (BOOL)validateNumber:(NSString*)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

//压缩图片
+ (UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


//去除emoji表情的方法
+ (NSString*)disable_EmojiString:(NSString *)text
{
    //去除表情规则
    //  \u0020-\\u007E  标点符号，大小写字母，数字
    //  \u00A0-\\u00BE  特殊标点  (¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾)
    //  \u2E80-\\uA4CF  繁简中文,日文，韩文 彝族文字
    //  \uF900-\\uFAFF  部分汉字
    //  \uFE30-\\uFE4F  特殊标点(︴︵︶︷︸︹)
    //  \uFF00-\\uFFEF  日文  (ｵｶｷｸｹｺｻ)
    //  \u2000-\\u201f  特殊字符(‐‑‒–—―‖‗‘’‚‛“”„‟)
    // 注：对照表 http://blog.csdn.net/hherima/article/details/9045765
    
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
    
    
    NSString* result = [expression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    
    return result;
}

//去除非中文的方法
+ (NSString*)disable_Non_CineseString:(NSString *)text
{
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\u4e00-\u9fa5]"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
    
    
    NSString* result = [expression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    
    return result;
}

#pragma mark - 判断沙盒文件是否存在
+ (BOOL)fileExistingWithFileName:(NSString *)fileName {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:plistPath];
}


#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma 正则只能输入数字和字母
+ (BOOL) checkTeshuZifuNumber:(NSString *) CheJiaNumber{
    NSString *bankNum=@"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CheJiaNumber];
    return isMatch;
}

+ (NSString *) nullDefultString: (NSString *)fromString null:(NSString *)nullStr{
    if ([fromString isEqualToString:@""] || [fromString isEqualToString:@"(null)"] || [fromString isEqualToString:@"<null>"] || [fromString isEqualToString:@"null"] || fromString==nil) {
        return nullStr;
    }else{
        return fromString;
    }
}

// 判断字符串为空或只为空格
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if([string isKindOfClass:[NSString class]] == NO)
    {
        return YES;
    }
    if(string.length == 0)
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string.lowercaseString isEqualToString:@"(null)"] || [string.lowercaseString isEqualToString:@"null"] || [string.lowercaseString isEqualToString:@"<null>"])
    {
        return YES;
    }
    return NO;
}

+ (NSString *)getMoneyStringWithMoneyNumber:(double)money {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    // 设置格式
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    return formattedNumberString;
}


+ (NSString *)connectedTogetherWithString:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return string;
}

@end
