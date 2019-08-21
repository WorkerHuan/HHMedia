//
//  HHMacroDefinition.h
//  HHMedia
//
//  Created by llbt on 2019/8/19.
//  Copyright © 2019 lianlong.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+HHColorChange.h"
#import "HHMacroDefinition.h"

#ifndef MacroDefinition_h
#define MacroDefinition_h

//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 宽高比
#define HHGetScalHeight(A) ((A)*((SCREEN_HEIGHT - ((isNotchIphone) ? 145 : 0))/667.0))
#define HHGetScalWidth(A) ((A)*(SCREEN_WIDTH/375.0))

//-------------------获取设备大小-------------------------


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

// 强弱引用
#define WeakSelf(A) __weak typeof(self)weakSelf = self
#define StrongSelf(A) __strong typeof(self)strongSelf = self

// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)  ((void)0)
#endif

#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
ITTDPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif

#define ITTAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)

//---------------------打印日志--------------------------


//----------------------系统----------------------------

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBValue(value) [UIColor colorWithRed:(value)/255.0f green:(value)/255.0f blue:(value)/255.0f alpha:(1)]
//----------------------颜色类--------------------------
#define HHWhiteColor [UIColor whiteColor]
#define HHBlueColor [UIColor blueColor]
#define HHBlackColor [UIColor blackColor]
#define HHOrangeColor [UIColor orangeColor]
#define HHGrayColor [UIColor grayColor]
#define HHYellowColor [UIColor yellowColor]
#define HHRedColor [UIColor redColor]
#define HHClearColor [UIColor clearColor]
#define HHColorWithHexString(name) [UIColor colorWithHexString:(name)]
#define HHLightBlueColorL RGBCOLOR(85,179,253)
//----------------------字体类--------------------------
#define HHFont(A) [UIFont systemFontOfSize:(A)]
#define HHFontNameSize(name,A) [UIFont fontWithName:(name) size:(A)]

//----------------------判断机型-----------------------
//刘海
#define isNotchIphone [HHMacroDefinition isNotchScreen]
//当前control
#define HHTopViewControl [HHMacroDefinition getTopViewControl]

/*状态栏高度*/
#define HHStatusBarHeight (CGFloat)(isNotchIphone?(44.0):(20.0))
/*导航栏高度*/
#define HHNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define HHNavBarAndStatusBarHeight (CGFloat)(isNotchIphone?(88.0):(64.0))
/*TabBar高度*/
#define HHTabBarHeight (CGFloat)(isNotchIphone?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define HHTopBarSafeHeight (CGFloat)(isNotchIphone?(44.0):(0))
/*底部安全区域远离高度*/
#define HHBottomSafeHeight (CGFloat)(isNotchIphone?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define HHTopBarDifHeight (CGFloat)(isNotchIphone?(24.0):(0))
/*导航条和Tabbar总高度*/
#define HHNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)

//#define is_iPhoneX
#define is_iPhoneX ({\
int tmp = 0;\
if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {\
if (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

#endif


NS_ASSUME_NONNULL_BEGIN

@interface HHMacroDefinition : NSObject
+(BOOL)isNotchScreen;

+(UIViewController *)getTopViewControl;

@end

NS_ASSUME_NONNULL_END
