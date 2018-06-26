//
//  WDBalanceSingleDCViewController.h
//  WalletDemo
//
//  Created by autoround-032 on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDViewControllerBase.h"

@class MBRWAccount;
@class MBRBgCoin;

/**
 账户币信息
 演示转账、支付功能
 */
@interface WDBalanceSingleDCViewController : WDViewControllerBase

@property(strong,nonatomic)MBRWAccount *account;
@property(strong,nonatomic)MBRBgCoin *coin;

@end
