//
//  WDDevice.h
//  WalletDemo
//
//  Created by liaofulin on 2018/3/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#define WDAnimationDuration 0.25f

#define WDScreenW [UIScreen mainScreen].bounds.size.width
#define WDScreenH [UIScreen mainScreen].bounds.size.height

#define WDIsPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define WDNavAndStatusHeight (WDIsPhoneX ? 88 : 64)

#define WDFitablePixel(p)  ((CGFloat)p*WDScreenW/375.f)
