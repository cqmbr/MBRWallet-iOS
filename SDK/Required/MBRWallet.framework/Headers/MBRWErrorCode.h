//
//  MBRWErrorCode.h
//  DCPay
//
//  Created by lfl on 2018/5/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

/*
 ** 错误码定义
 */

#import <Foundation/Foundation.h>

/// errorDomain
extern NSString * const MBRWErrorDomain;

/// error userInfo中对应的key
extern NSString * const MBRWErrorKey;

/// 未知错误
extern NSString * const MBRWErrorCode_Unknown;

#pragma mark - 密码
/// 输入的密码为空
extern NSString * const MBRWErrorCode_Pwd_None;

/// 钱包交易密码不存在，未设置
extern NSString * const MBRWErrorCode_Pwd_NotExist;

/// 密码已经存在
extern NSString * const MBRWErrorCode_Pwd_Exist;

/// 密码不相同
extern NSString * const MBRWErrorCode_Pwd_NotSame;

/// 密码一样
extern NSString * const MBRWErrorCode_Pwd_Same;

#pragma mark -
/// 账号名为空
extern NSString * const MBRWErrorCode_Acc_None;

/// 账户名已经存在
extern NSString * const MBRWErrorCode_Acc_Exist;

/// 账户地址已存在
extern NSString * const MBRWErrorCode_AccAddress_Exist;

/// 账户名不存在
extern NSString * const MBRWErrorCode_Acc_NotExist;

/// 账户地址不存在
extern NSString * const MBRWErrorCode_AccAddress_NotExist;



/// 助记词导入，助记词为空
extern NSString * const MBRWErrorCode_Mnemonic_None;

/// 导入时，助记词不匹配
extern NSString * const MBRWErrorCode_Mnemonic_NotMatch;

/// keystore导入，keystore为空
extern NSString * const MBRWErrorCode_Keystore_None;

/// keystore导入，keystore密码为空
extern NSString * const MBRWErrorCode_Keystore_Pwd_None;
extern NSString * const MBRWErrorCode_Keystore_PwdNotMatch;

extern NSString * const MBRWErrorCode_InputPraram_Error;
/// 余额不足
extern NSString * const MBRWErrorCode_Tran_BalanceInsufficient;
/// 扣除矿工费后余额不足
extern NSString * const MBRWErrorCode_Tran_FeeInsufficient;
/// 设备不支持touchid
extern NSString * const MBRWErrorCode_Device_NotSupprtTouchID;
/// touchid验证失败
extern NSString * const MBRWErrorCode_TouchID_Verify_Fail;
/// 账户中代币不存在
extern NSString * const MBRWErrorCode_Coin_NotExist;
