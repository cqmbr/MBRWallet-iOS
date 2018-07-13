//
//  MBRWErrorCode.h
//  MBRWallet
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
extern NSString * const WALLET_UNKNOWN_ERROR;

#pragma mark - 密码
/// 输入的密码为空
extern NSString * const PASSWORD_EMPTY_ERROR;

/// 钱包交易密码不存在，未设置
extern NSString * const PASSWORD_NO_ERROR;

/// 密码已经存在
extern NSString * const PASSWORD_SET_FAIL_FOR_ALREADY_SET;

/// 密码不相同
extern NSString * const PASSWORD_ERROR;

/// 密码一样
extern NSString * const PASSWORD_MODIFY_NEWPWD_SAME_TO_OLDPWD_ERROR;

#pragma mark -
/// 账号名为空
extern NSString * const ACCOUNT_NAME_EMPTY_ERROR;

/// 账户名已经存在
extern NSString * const ACCOUNT_NAME_DUPLICATE_ERROR;

/// 账户地址已存在
extern NSString * const ACCOUNT_DUPLICATE_ERROR;

/// 账户不存在
extern NSString * const ACCOUNT_NOT_EXIST_ERROR;


/// 助记词导入，助记词为空
extern NSString * const MNEMONIC_EMPTY_ERROR;

/// 导入时，助记词不匹配
extern NSString * const MNEMONIC_ERROR;

/// keystore导入，keystore为空
extern NSString * const KEYSTORE_EMPTY_ERROR;

/// keystore导入，keystore密码为空
extern NSString * const KEYSTORE_PWD_EMPTY_ERROR;
extern NSString * const KEYSTORE_ERROR;

extern NSString * const PAY_PRAMAM_ERROR;
/// 余额不足
extern NSString * const PAY_BALANCE_NOT_ENOUGH_ERROR;
/// 扣除矿工费后余额不足
extern NSString * const PAY_FEE_NOT_ENOUGH_ERROR;
/// 设备不支持touchid
extern NSString * const FINGER_UNAVAILABLE_ERROR;
/// touchid验证失败
extern NSString * const FINGERPRINT_ERROR;
/// 账户中代币不存在
extern NSString * const ACCOUNT_COIN_NOT_EXIST_ERROR;

#pragma mark - 用户相关
//若多用户情况，未设置钱包id，调用API的情况下会检测此配置
extern NSString * const NO_WALLET_ERROR_CODE;

//用户模式不支持
extern NSString * const WALLET_MODE_NOT_SUPPORTED_CODE;

//钱包数据删除失败
extern NSString * const WALLET_DELETE_FAIL_CODE;

