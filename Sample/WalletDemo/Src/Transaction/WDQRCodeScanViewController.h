//
//  WDQRCodeScanViewController.h
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDViewControllerBase.h"

@protocol WDQRCodeScanViewControllerDelegate <NSObject>

/**
 *  扫描成功后返回扫描到数据
 */
-(void)qRCodeScanViewController:(UIViewController *)controller value:(NSString *)value;

@end

/**
 交易二维码
 */
@interface WDQRCodeScanViewController : WDViewControllerBase

@property (nonatomic, weak) id<WDQRCodeScanViewControllerDelegate> delegate;

@end
