//
//  NSString+Extension.m
//  汇银
//
//  Created by 李小斌 on 14-11-27.
//  Copyright (c) 2014年 7ien. All rights reserved.
//

#import "NSString+Extension.h"
#include <ifaddrs.h>

#include <arpa/inet.h>

#include <net/if.h>

@implementation NSString (Extension)


+(NSString *) priceWithSign:(CGFloat)value
{
    return [NSString stringWithFormat:@"￥%.2f", value];
}

+(NSString *) priceWithoutSign:(CGFloat)value
{
    return [NSString stringWithFormat:@"%0.2f", value];
}

+(NSString *)jsonUtils:(id)stringValue
{
    NSString *string = [NSString stringWithFormat:@"%@", stringValue];
    
    if([string isEqualToString:@"<null>"])
    {
        string = @"";
    }
    
    if(string == nil)
    {
        string = @"";
    }
    
    if([string isEqualToString:@"(null)"])
    {
        string = @"";
    }
    if([string isEqualToString:@"<null>"])
    {
        string = @"";
    }
    
    if([string isEqualToString:@""])
    {
        string = @"";
    }
    
    if(string.length == 0)
    {
        string = @"";
    }
    
    return string;
}

+(NSString *)jsonUtils22:(id)stringValue
{
    NSString *string = [NSString stringWithFormat:@"%@", stringValue];
    
    if([string isEqualToString:@"<null>"])
    {
        string = @"0";
    }
    
    if(string == nil)
    {
        string = @"0";
    }
    
    if([string isEqualToString:@"(null)"])
    {
        string = @"0";
    }
    
    if([string isEqualToString:@""])
    {
        string = @"0";
    }
    
    if(string.length == 0)
    {
        string = @"0";
    }
    
    return string;
}



+(NSString *)stringUtils:(id)stringValue
{
    NSString *string = [NSString stringWithFormat:@"%@", stringValue];
    
    if([string isEqualToString:@"<null>"])
    {
        string = @"";
    }
    
    if(string == nil)
    {
        string = @"";
    }
    
    if([string isEqualToString:@"(null)"])
    {
        string = @"";
    }
    
    if(string.length == 0)
    {
        string = @"";
    }
    
    return string;
}

/*
 * 判断字符串是否为空白的
 */
- (BOOL)isBlank
{
    if ((self == nil) || (self.length == 0)) {
        return YES;
    }
    
    NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimedString length] == 0) {
        return YES;
    } else {
        return NO;
    }
    
    return YES;
}

/*
 * 判断字符串是否为空
 */
- (BOOL)isEmpty
{
    
    return (([self isKindOfClass:[NSNull class]])  || [self isEqual:[NSNull null]]||(self.length == 0) || (self == nil)|| ([self isEqualToString:@"(null)"]) || ([self isEqualToString:@"<null>"]));
}


 + (BOOL)isEmpty:(id)stringValue
 {
     NSString *string = [NSString stringWithFormat:@"%@", stringValue];
     return (([string isKindOfClass:[NSNull class]])  || [string isEqual:[NSNull null]]||(string.length == 0) || (string == nil)|| ([string isEqualToString:@"(null)"]) || ([string isEqualToString:@"<null>"]) || ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]));
 }

- (BOOL)isNULL
{
    return [self isKindOfClass:[NSNull class]] || [self isEqual:[NSNull null]];
}


// 把手机号第4-7位变成星号
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum
{
    if (phoneNum.length>=7) {
        return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    }
    return phoneNum;
}

// 把邮箱@前面变成星号
+(NSString*)emailToAsterisk:(NSString *)email
{
    NSArray *arr = [email componentsSeparatedByString:@"@"];
    NSString *str = [arr objectAtIndex:0];
    return [email stringByReplacingCharactersInRange:NSMakeRange(str.length, email.length-str.length) withString:@"****"];
}

// 把身份证号第11-14位变成星号
+(NSString*)idCardToAsterisk:(NSString *)idCardNum
{
    return [idCardNum stringByReplacingCharactersInRange:NSMakeRange(10, 4) withString:@"****"];
}

//邮箱验证
+ (BOOL) validateEmail:(NSString *)email
{//564826150@qq.com
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断字符串中是否含有表情-------系统键盘有问题
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
//    Vindor标示符 (IDFV-identifierForVendor)
+ (NSString *)returnIdfv
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    EXLog(@"idfv...%@",idfv);
    return idfv;
}
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(16[0-9])|(17[0-9])|(18[0,0-9]|(19[0-9])))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
/*
 
 NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))(\\d{8})$";
	NSPredicate *regextesPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
	if ([regextesPhone evaluateWithObject:self] == YES)
	{
 return YES;
	}
	else
	{
 return NO;
	}
 */
}

//固话验证
+ (BOOL) validateAreaTel:(NSString *)areaTel;
{
    NSString *phoneRegex = @"^((0\\d{2,3})-)(\\d{7,8})(-(\\d{3,}))?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:areaTel];
    
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

/**
 * 功能:获取指定范围的字符串
 *
 * 参数:字符串的开始下标
 *
 * 参数:字符串的结束下标
 */
+(NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2;
{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}

/**
 * 功能:判断是否在地区码内
 *
 * 参数:地区码
 */
+(BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

/**
 * 功能:验证身份证是否合法
 *
 * 参数:输入的身份证号
 */
+(BOOL)validateIdCard:(NSString *)idCard
{
    //判断位数
    if ([idCard length] < 15 ||[idCard length] > 18) {
        return NO;
    }
    
    NSString *carid = idCard;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:idCard];
    if ([idCard length] == 15) {
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    
    //年份
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}

//通过文本宽度计算高度
-(CGSize) calculateSize:(UIFont *)font maxWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width,1000);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return CGSizeMake(rect.size.width, rect.size.height);
}

//重写containsString方法，兼容8.0以下版本
- (BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0){
    if ([aString isBlank]) {
        return NO;
    }
    if ([self rangeOfString:aString].location != NSNotFound) {
        return YES;
    }
    return NO;
}

//json数组转换成字符串
+(NSString *) jsonStringWithArray:(NSArray *)array
{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

//字典转换成字符串
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary
{
    NSString *jsonString = nil;
    NSError *error;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!data) {
//        EXLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

////json字符串转换成普通字符串
+(NSString *) jsonStringWithString:(NSString *) string
{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

////json对象转换成字符串
+(NSString *) jsonStringWithObject:(id) object
{
    NSString *value = nil;
    if (!object)
    {
        return value;
    }
    if ([object isKindOfClass:[NSString class]])
    {
        value = [self jsonStringWithString:object];
    }
    else if([object isKindOfClass:[NSDictionary class]])
    {
        value = [self jsonStringWithDictionary:object];
    }
    else if([object isKindOfClass:[NSArray class]])
    {
        value = [self jsonStringWithArray:object];
    }
    return value;
}


//字符串转成字典
+ (NSDictionary *)dicWithString:(NSString *)string
{
    if (string == nil) {
        return nil;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+ (NSString *)URLEncodedString:(NSString *)urlString
{
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)urlString,
                                                              
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              
                                                              NULL,
                                                              
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


//1、自己下载速度这种，可以直接在接受数据的地方加统计
//2、获取全局的数据，可以监控网卡的进出流量
/*获取网络流量信息*/
+ (long long) getInterfaceBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    
//    EXLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes,oBytes);
    return iBytes + oBytes;
}


+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
    
}


#pragma mark - 计算缓存大小
+ (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    CGFloat sumSize = 0;
    
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        //2）.计算文件的大小
        CGFloat fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    float size_m = sumSize/(1024*1024);
    //SDWebImage框架自身计算缓存的实现
    size_m += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    
    
    return [NSString stringWithFormat:@"%.2fM",size_m];
    
}

//根据正则，过滤特殊字符
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}


//有效数字
- (BOOL)yw_isValidateDecimalsNum{
    BOOL isValid = YES;
    NSUInteger len = self.length;
    if (len > 0) {
        NSString *numberRegex = @"^[-+]?[0-9]*\\.?[0-9]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:self];
    }
    return isValid;
}

//判断全字母：
- (BOOL)inputShouldLetter:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}


//判断仅输入字母或数字：
- (BOOL)inputShouldLetterOrNum:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attribute = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}


/*
 // 对一个字符串进行base64编码,并且返回
 -(NSString *)base64EncodeString:(NSString *)string {
 // 1.先转换为二进制数据
 NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
 // 2.对二进制数据进行base64编码,完成之后返回字符串
 return [data base64EncodedStringWithOptions:0];
 }
 // 对base64编码之后的字符串解码,并且返回
 -(NSString *)base64DecodeString:(NSString *)string {
 // 注意:该字符串是base64编码后的字符串
 // 1.转换为二进制数据(完成了解码的过程)
 NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
 // 2.把二进制数据在转换为字符串
 return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 }
 //---------------------------<#我是分割线#>------------------------------//
 NSLog(@"%@",[self base64EncodeString:@"A"]);
 NSLog(@"%@",[self base64DecodeString:@"QQ=="]);
 */

+(void)setLabelSpaceWithLabel:(UILabel*)label withTextStr:(NSString*)textStr withFont:(UIFont*)font withLineSpacing:(NSInteger)lineSpacing
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:textStr attributes:dic];
    label.attributedText = attributeStr;
}

+(CGFloat)getSpaceLabelHeightWithText:(NSString*)textStr withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpacing:(NSInteger)lineSpacing{
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    if (lineSpacing) {
        style.lineSpacing = lineSpacing;
    } else {
        style.lineSpacing = 0;
    }
    
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:textStr attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    CGSize size =  [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    CGFloat height = ceil(size.height) + 1;
    
    return height;
}

@end
