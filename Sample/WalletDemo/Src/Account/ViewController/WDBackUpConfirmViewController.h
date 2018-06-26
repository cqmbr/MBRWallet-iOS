//
//  WDBackUpConfirmViewController.h
//  WalletDemo
//
//  Created by sean on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDViewControllerBase.h"

@interface WDBackUpConfirmViewController : WDViewControllerBase
@property(strong,nonatomic)NSString *mnemonicString;
@property(strong,nonatomic)NSString *address;
@property (nonatomic, copy) NSString* tmpPwd;

@end
