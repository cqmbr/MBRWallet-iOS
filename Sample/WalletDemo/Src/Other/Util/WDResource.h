//
//  WDResource.h
//  WalletDemo
//
//  Created by liaofulin on 2018/3/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <YYCategories/UIColor+YYAdd.h>

// 颜色
#define WDMainColor UIColorHex(#363A44)
#define WDWhiteColor [UIColor whiteColor]
#define WDBlackColor [UIColor blackColor]
#define WDGrayColor [UIColor grayColor]
#define WDColor_1 UIColorHex(#363A44)
#define WDColor_2 UIColorHex(#1F2127)
#define WDColor_3 UIColorHex(#34A9FF)
#define WDColor_4 UIColorHex(#979797)
#define WDColor_5 UIColorHex(#5D5C71)
#define WDColor_6 UIColorHex(#F4F4F4)
#define WDColor_7 UIColorHex(#F2F2F2)
#define WDColor_8 UIColorHex(#FF6960)
#define WDColor_9 UIColorHex(#1E1C2A)
#define WDColor_10 UIColorHex(#00BD9A)
#define WDColor_11 UIColorHex(#B3B3BA)
#define WDColor_12 UIColorHex(#FEBE17)
#define WD_TextBorderColor UIColorHex(#353944)
//按钮字体蓝色
#define WDBtnBlueColor UIColorHex(#34A9FF)

//Payment
#define WDColorPaymentWallet UIColorHex(#353342)
#define WDColorPaymentStatus UIColorHex(#5D5C70)
#define WDColorPaymentRecent UIColorHex(#6D6C7E)

//Balance
#define WDColorBalanceWarning UIColorHex(#FEBE17)

// 分割线
#define WDLineColor_3 UIColorHex(#353343)

// 字体
#define WDFont_12 [UIFont systemFontOfSize:12]
#define WDFont_13 [UIFont systemFontOfSize:13]
#define WDFont_14 [UIFont systemFontOfSize:14]
#define WDFont_15 [UIFont systemFontOfSize:15]
#define WDFont_16 [UIFont systemFontOfSize:16]
#define WDFont_17 [UIFont systemFontOfSize:17]
#define WDFont_18 [UIFont systemFontOfSize:18]
#define WDFont_19 [UIFont systemFontOfSize:19]
#define WDFont_20 [UIFont systemFontOfSize:20]
#define WDFont_24 [UIFont systemFontOfSize:24]
#define WDFont_48 [UIFont systemFontOfSize:48]

#pragma mark - 判断空值
//判断空数组
#define ISNULLARRAY(arr) (arr == nil || (NSObject *)arr == [NSNull null] || arr.count == 0)
// 判断空值
#define ISNULL(obj)      (obj == nil || (NSObject *)obj == [NSNull null])
//判断空字符串
#define ISNULLSTR(str)   (str == nil || (NSObject *)str == [NSNull null] || str.length == 0 || [str isEqualToString:@"(null)"])


//数据太长无法在控制台完全输出，用WDLog可解决
#ifdef DEBUG
#define WDLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define WDLog(format, ...)

#endif

