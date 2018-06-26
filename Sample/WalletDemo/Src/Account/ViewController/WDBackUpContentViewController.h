//
//  WDBackUpContentViewController.h
//  WalletDemo
//
//  Created by sean on 2018/4/9.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDViewControllerBase.h"

@class MBRWAccount;
@interface WDBackUpContentViewController : WDViewControllerBase

@property (nonatomic, strong) MBRWAccount* account;
@property (nonatomic, copy) NSString* tmpPwd;

@end
