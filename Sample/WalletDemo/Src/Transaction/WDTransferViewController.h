//
//  WDTransferViewController.h
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//  转账界面

#import "WDViewControllerBase.h"

@class MBRWAccount;
@class MBRBgCoin;
/**
 转账界面
 */
@interface WDTransferViewController : WDViewControllerBase

// 转出账户
@property (nonatomic, strong) MBRWAccount* account;
// 支付币
@property (nonatomic, strong) MBRBgCoin* coinData;
// 转入地址
@property (nonatomic, copy) NSString* receiverAddress;

@end
