//
//  WDUIPrefix.h
//  WalletDemo
//
//  Created by liaofulin on 2018/3/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "WDDevice.h"
#import "WDResource.h"
#import <MBProgressHUD+BWMExtension/MBProgressHUD+BWMExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import "WDToastUtil.h"

#define WDScreenW [UIScreen mainScreen].bounds.size.width
#define WDScreenH [UIScreen mainScreen].bounds.size.height

#define WD_IsPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
