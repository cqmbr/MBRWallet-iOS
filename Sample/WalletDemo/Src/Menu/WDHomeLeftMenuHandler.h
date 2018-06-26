//
//  WDHomeLeftMenuHandler.h
//  WalletDemo
//
//  Created by lfl on 2018/5/21.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 menu菜单显示处理类
 */
@interface WDHomeLeftMenuHandler : NSObject

/**
 源控制器
 */
@property (nonatomic, weak) UIViewController* srcVc;

/**
 显示左侧菜单
 */
- (void)showMenuView;

@end
