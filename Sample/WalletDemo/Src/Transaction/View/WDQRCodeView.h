//
//  WDQRCodeView.h
//  WalletDemo
//
//  Created by zhanbin on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>

// 地址二维码
@interface WDQRCodeView : UIView

- (instancetype)initWithAccountName:(NSString *)accountName                            address:(NSString *)address;

- (void)show;

@end
