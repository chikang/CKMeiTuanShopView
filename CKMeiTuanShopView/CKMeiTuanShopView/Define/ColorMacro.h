//
//  ColorMacro.h
//  exsd
//
//  Created by CK on 2017/3/8.
//  Copyright © 2017年 CK. All rights reserved.
// 颜色

#ifndef ColorMacro_h
#define ColorMacro_h




#define kColor(hexStr)            [AppMethods colorWithHexString:hexStr]

#define Title_Style      @"PingFangSC-Regular"

#define Kcolor_NavColor           kColor(@"#FD5151")//红色,主题颜色
#define kColor_TitleColor         kColor(@"#666666")//标题颜色
#define kColor_GrayColor          kColor(@"#999999")
#define kColor_CircleColor        kColor(@"#F85F4F")//红色圆圈颜色
#define kColor_darkGrayColor      kColor(@"#000000")//黑色背景
#define kColor_borderColor        kColor(@"#EEEEEE")//边框
#define kColor_bgHeaderViewColor  kColor(@"#E2E2E2")
#define kColor_darkBlackColor     kColor(@"#333333")//黑色字体
#define kColor_blueColor          kColor(@"#0076FF")//蓝色字体
#define kColor_ButonCornerColor   kColor(@"#D9D9D9")
#define kColor_LightGrayColor     kColor(@"#F0EFED")//灰色背景
#define kColor_bgViewColor        kColor(@"#F9F9F9")
#define kColor_ReplyColor         kColor(@"#535353")//


#define KColor_AlertViewBg        RGBA(0, 0, 0, 0.4) //弹窗口背景的灰色

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RBG颜色
#define RGB(r,g,b)               [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

//RGBA颜色
#define RGBA(r,g,b,a)            [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#endif /* ColorMacro_h */
