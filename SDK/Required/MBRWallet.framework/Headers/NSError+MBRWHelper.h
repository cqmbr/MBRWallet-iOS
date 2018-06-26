//
//  NSError+MBRWHelper.h
//  MBRWallet
//
//  Created by lfl on 2018/5/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBRWErrorCode.h"

/**
 钱包错误码辅助类
 */
@interface NSError (MBRWHelper)

/**
 是否为钱包产生的错误码

 @return BOOL
 */
- (BOOL)mbrw_isWalletError;

/**
 获取错误码code
 mbrw_isWalletError = YES : 返回钱包自定义的错误码
 mbrw_isWalletError = NO : 返回NSError的code字符串
 @return 错误码
 */
- (NSString *)mbrw_errorCode;

/**
 构造钱包错误码

 @param code code
 @return NSError
 */
+ (NSError*)mbrw_errorWithCode:(NSString*)code;

@end
