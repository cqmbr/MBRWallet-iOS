//
//  WDToastUtil.m
//  WalletDemo
//
//  Created by lfl on 2018/6/21.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDToastUtil.h"
#import <MBProgressHUD+BWMExtension/MBProgressHUD+BWMExtension.h>
#import <MBRWallet/NSError+MBRWHelper.h>
#import "WDResource.h"


@implementation WDToastUtil

+ (void)showLoadingInView:(UIView*)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD bwm_showHUDAddedTo:view title:nil];
}

+ (void)hideInView:(UIView*)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

+ (void)showToast:(NSString*)text InView:(UIView*)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD bwm_showTitle:text toView:view hideAfter:2];
}

+ (void)showError:(NSError*)error view:(UIView*)view {
    [self showToast:[self parseError:error] InView:view];
}

+ (NSString*)parseError:(NSError*)error {
    
    NSString *text = nil;
    if ([error mbrw_isWalletError]) {
        // 钱包错误码转提示语
        text = [self textFromWalletErrorCode:[error mbrw_errorCode]];
    }
    
    if (text == nil) {
        // 获取error描述信息
        text = error.description;
    }
    if (text == nil) {
        text = @"";
    }
    
    return text;
}

// 钱包错误码转换为对应的提示语
+ (NSString*)textFromWalletErrorCode:(NSString*)code {
    if (code == nil) {
        return nil;
    }
    
    // 密码
    if ([code isEqualToString:PASSWORD_EMPTY_ERROR]) {
        return @"密码不能为空";
    } else if ([code isEqualToString:PASSWORD_NO_ERROR]) {
        return @"您还没有设置密码，请先设置密码";
    } else if ([code isEqualToString:PASSWORD_SET_FAIL_FOR_ALREADY_SET]) {
        return @"密码已经设置过，可使用修改密码修改";
    } else if ([code isEqualToString:PASSWORD_ERROR]) {
        return @"密码错误";
    } else if ([code isEqualToString:PASSWORD_MODIFY_NEWPWD_SAME_TO_OLDPWD_ERROR]) {
        return @"新密码不能与旧密码一样";
    }
    
    // 账户
    else if ([code isEqualToString:ACCOUNT_NAME_EMPTY_ERROR]) {
        return @"账户名不能为空";
    } else if ([code isEqualToString:ACCOUNT_NAME_DUPLICATE_ERROR]) {
        return @"账号已经存在，请换一个名称";
    } else if ([code isEqualToString:ACCOUNT_NOT_EXIST_ERROR]) {
        // 账户不存在
        return @"账户不存在";
    } else if ([code isEqualToString:ACCOUNT_DUPLICATE_ERROR]) {
        return @"账户已经存在";
    }
    
    // 助记词，keystore
    else if ([code isEqualToString:MNEMONIC_EMPTY_ERROR]) {
        return @"助记词不能为空";
    } else if ([code isEqualToString:MNEMONIC_ERROR]) {
        return @"助记词无效，请检测";
    } else if ([code isEqualToString:KEYSTORE_EMPTY_ERROR]) {
        return @"keystore不能为空";
    } else if ([code isEqualToString:KEYSTORE_PWD_EMPTY_ERROR]) {
        return @"keystore密码不能为空";
    } else if ([code isEqualToString:KEYSTORE_ERROR]) {
        return @"keystore或者密码不正确";
    }
    
    // 转账交易
    else if ([code isEqualToString:PAY_BALANCE_NOT_ENOUGH_ERROR]) {
        return @"该账户余额不足";
    } else if ([code isEqualToString:PAY_FEE_NOT_ENOUGH_ERROR]) {
        return @"扣除矿工费后余额不足";
    } else if ([code isEqualToString:FINGER_UNAVAILABLE_ERROR]) {
        return @"不支持指纹验证";
    } else if ([code isEqualToString:FINGERPRINT_ERROR]) {
        return @"指纹验证失败";
    } else if ([code isEqualToString:ACCOUNT_COIN_NOT_EXIST_ERROR]) {
        return @"未找到对应的币";
    }
    
    // 其他
    else if ([code isEqualToString:PAY_PRAMAM_ERROR]) {
        return code;
    } else if ([code isEqualToString:WALLET_UNKNOWN_ERROR]) {
        return code;
    } else {
        return code;
    }
    
    return nil;
    
}

@end
