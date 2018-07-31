//
//  AppDefaultUtil.m
//  SP2P_6.1
//
//

#import "AppDefaultUtil.h"
#import <arpa/inet.h>
#import <ifaddrs.h>

static AppDefaultUtil *_sharedClient = nil;
static dispatch_once_t onceToken;


@interface AppDefaultUtil()


@end

@implementation AppDefaultUtil

//+ (void)clear {
//    onceToken = 0;
//}

+ (instancetype)sharedInstance {
    
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[AppDefaultUtil alloc] init];
    
    });
    
    return _sharedClient;
}

//图文混排，插入图片
+ (NSMutableAttributedString *)addAttribute:(NSString *)name withImg:(UIImage *)image withImgSize:(CGRect)bounds insertIndex:(NSInteger)index
{
    //1：先创建富文本
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:name];
    //设置富文本中的不同文字的样式
    //    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 5)];
    //    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 5)];
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    // 表情图片
    attchImage.image = image;
    // 设置图片大小
    attchImage.bounds = bounds;
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:index];
    return  attriStr;
}

+(NSMutableAttributedString *)returnLineSpacingWithStr:(NSString *)labelText  withLineSpacing:(CGFloat)lineCount withTextAlignmentCenter:(NSTextAlignment )alignment
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineCount];//调整行间距
    [paragraphStyle setAlignment:alignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    return attributedString;
}

+(NSMutableAttributedString *)returnLineSpacingWithStr22:(NSMutableAttributedString *)labelText  withLineSpacing:(CGFloat)lineCount withTextAlignmentCenter:(NSTextAlignment )alignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineCount];//调整行间距
    [paragraphStyle setAlignment:alignment];
    [labelText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    return labelText;
}


+ (NSMutableAttributedString *)returnStringColor:(NSString *)string rang:(NSRange)rang color:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:color range:rang];
//    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TextSize(15)],NSForegroundColorAttributeName:BLACK_COLOR} range:NSMakeRange(7, timeString.length-7)];
    return  str;
}

+ (NSMutableAttributedString *)returnStringSize:(NSString *)string rang:(NSRange)rang size:(CGFloat)size
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size ] range:rang];
    return  str;
}

@end
