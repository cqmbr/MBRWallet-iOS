//
//  WDConfigManager.h
//  WalletDemo
//
//  Created by lfl on 2018/7/11.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDConfigManager : NSObject

#pragma mark - 使用钱包配置参数
/**
 app私钥
 */
+ (NSString*)privateKey;

/**
 商户id
 */
+ (NSString*)merchantId;

/**
 渠道
 */
+ (NSString*)channel;

/**
 服务地址
 */
+ (NSString*)apiHost;

@end
