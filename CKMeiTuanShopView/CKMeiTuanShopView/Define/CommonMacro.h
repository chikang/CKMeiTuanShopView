//
//  CommonMacro.h
//  exsd
//
//  Created by CK on 2017/4/12.
//  Copyright © 2017年 CK. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h


#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define MAS_VIEW UIView
#define MASEdgeInsets UIEdgeInsets
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#define MAS_VIEW NSView
#define MASEdgeInsets NSEdgeInsets
#endif
// 定义这个常量，就可以不用在开发过程中使用"mas_"前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS


#define  takeawayLeft_W   kScreenWidth * (75.0/375)
#define  takeawayRight_W  kScreenWidth * (300.0/375)

//获取当前屏幕的高度
#define kScreenHeight             ([UIScreen mainScreen].bounds.size.height)
//获取当前屏幕的宽度
#define kScreenWidth              ([UIScreen mainScreen].bounds.size.width)

// 适配 等比放大控件
#define Size(x)                   ((x)*kScreenWidth*1.0/375.0)
#define SizeInt(x)                   ((NSInteger)((x)*kScreenWidth/375))
// 应用程序总代理
#define AppDelegateInstance	      ((AppDelegate*)([UIApplication sharedApplication].delegate))


//占位图片
#define Image_placeholder          [UIImage imageNamed:@"thumb"]
#define Image_placeholder_nologo          [UIImage imageNamed:@"defaultBack.jpeg"]

#define ImageHeight_placeholder    66

//图片压缩参数
#define kMaxImageSize 1500

#define kMaxSizeWithKB 1536.0



//图片
#define kImage_Path(file,type)    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:type]]
#define kImage_Name(name)         [UIImage imageNamed:name]

//字体
#define kFont(fontSize)           [UIFont systemFontOfSize:fontSize]

#define kFontNameSize(fontNameSize)            [UIFont fontWithName:@"PingFang-SC-Medium" size:fontNameSize]

#define kDefalutCellHeight 44

//HUD显示时间
#define kDelayTime 1.5
/// 分割线高度
#define KCOMMON_LINE_HEIGHT 0.6
/// 蒙版透明度
#define KMASK_ALPHA 0.5
/// 弹框动画时间
#define KPOPVIEW_ANIMATE_DURATION 0.25

//获取系统版本
#define Ios_Version              [[[UIDevice currentDevice] systemVersion] floatValue]

//获取当前语言
#define CurrentLanguage           ([NSLocale preferredLanguages] objectAtIndex:0])

#define IsiPhone5                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), ［UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPAD                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA                 ([[UIScreen mainScreen] scale] >= 2.0)

// 默认导航栏、标签栏高度
#define kDefaultNavBarHeight (kIsiPhoneX ? 88.0 : ((kSystemVersion < 7.0) ? 44.0 : 64.0))
#define kDefaultTabBarHeight (kIsiPhoneX ? 83.0 : 49.0)
#define kDefaultStatusBarHeight (kIsiPhoneX ? 44.0 : 20.0)
#define kDefaultNavBar_SubView_MinY (kIsiPhoneX ? 24.0 : 0.0)//导航条子视图默认最小Y坐标
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (kIsiPhoneX ? 34 : 0)
#define IPHONE_TOPSENSOR_HEIGHT      (kIsiPhoneX ? 32 : 0)
#define kNavFrame                 CGRectMake(0, 0, kScreenWidth, kDefaultNavBarHeight)


// 判断是否为 iPhone 3/3GS/4/4S
#define kIsiPhone4 (kScreenWidth == 320.0 && kScreenHeight == 480.0)
// 判断是否为 iPhone 5/5S/5C/SE
#define kIsiPhone5 (kScreenWidth == 320.0 && kScreenHeight == 568.0)
// 判断是否为iPhone 6/6S/7/8
#define kIsiPhone6 (kScreenWidth == 375.0 && kScreenHeight == 667.0)
// 判断是否为iPhone 6Plus/6SPlus/7Plus/8Plus
#define kIsiPhone6Plus (kScreenWidth == 414.0 && kScreenHeight == 736.0)
// 判断是否为iPhoneX
#define kIsiPhoneX (kScreenWidth == 375.0 && kScreenHeight == 812.0)


// 系统版本
#define kSystemVersion ([[UIDevice currentDevice].systemVersion floatValue])

// 高清屏检测
#define kIsRetina ([[UIScreen mainScreen] scale] > 1)

#define SINGLE_LINE_WIDTH           (1.0 / [UIScreen mainScreen].scale)

#define SINGLE_LINE_ADJUST_OFFSET   ((1.0 / [UIScreen mainScreen].scale) / 2)

// 最大尺寸
#define kMaxCGSize CGSizeMake(MAXFLOAT, MAXFLOAT)

// 国际化文本读取
#define THLoc(__table__) NSLocalizedString(__table__, nil)


// 模拟器与真机区别
#if TARGET_IPHONE_SIMULATOR
#define kIsSimulator 1
#else
#define kIsSimulator 0
#endif



//数据验证

#define StrValid(f)(f!=nil &&[f isKindOfClass:[NSString class]]&& ![f isEqualToString:@""])

#define SafeStr(f)(StrValid(f)?f:@"")

#define HasString(str,eky)([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f)StrValid(f)

#define ValidDict(f)(f!=nil &&[f isKindOfClass:[NSDictionary class]])

#define ValidArray(f)(f!=nil &&[f isKindOfClass:[NSArray class]]&&[f count]>0)

#define ValidNum(f)(f!=nil &&[f isKindOfClass:[NSNumber class]])

#define ValidClass(f,cls)(f!=nil &&[f isKindOfClass:[cls class]])

#define ValidData(f)(f!=nil &&[f isKindOfClass:[NSData class]])

#define MyDefaults                  ([NSUserDefaults standardUserDefaults])
#define MyFileManager               ([NSFileManager defaultManager])

// Path
#define DocumentsPath               [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

// block引用self或者其它对象宏
//#define WeakObject(type)  __weak __typeof(&*type) weak##_##type = type;
/** 避免self的提前释放 */
#define STRONGSELF __weak typeof(weakSelf) strongSelf = weakSelf


#endif /* CommonMacro_h */
