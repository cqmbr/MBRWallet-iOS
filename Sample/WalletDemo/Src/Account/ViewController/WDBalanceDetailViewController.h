//
//  WDBalanceDetailViewController.h
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDViewControllerBase.h"

// 账户详情页
@class MBRWAccount;
@interface WDBalanceDetailViewController : WDViewControllerBase

@property (nonatomic, strong) MBRWAccount* account;

@end
