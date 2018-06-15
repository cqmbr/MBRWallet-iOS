//
//  MBRWWallet+Transaction.h
//  DCPay
//
//  Created by lfl on 2018/6/5.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "MBRWWallet.h"

NS_ASSUME_NONNULL_BEGIN

/**
 交易成功回调
 */
typedef void(^MBRWTransactionSuccessBlock)(void);

@class MBRBgCoin;
/**
 转账参数
 */
@interface MBRWTransferParam:NSObject

/**
 交易使用的币ID
 */
@property (nonatomic, copy) NSString* coinId;

@property (nonatomic, strong, nullable) MBRBgCoin* coin;


/**
 转出账户地址，必须
 */
@property (nonatomic, copy) NSString* addressFrom;

/**
 转入账户，非必须
 */
@property (nonatomic, copy) NSString* addressTo;

/**
 转出币数量，必须
 */
@property (nonatomic, copy) NSString* amountStr;

/**
  矿工费，必须
 */
@property (nonatomic, copy) NSString* feeStr;

/**
 备注，非必须
 */
@property (nonatomic, copy, nullable) NSString* memo;

@end

/**
 支付参数
 */
@interface MBRWPayParam:NSObject

/**
 订单信息，必须
 */
@property (nonatomic, copy) NSString* orderInfo;
@property (nonatomic, strong, nullable) NSDictionary* orderDic;

/**
 转出账户地址，必须
 */
@property (nonatomic, copy) NSString* addressFrom;

/**
 矿工费，必须
 */
@property (nonatomic, copy) NSString* feeStr;

/**
 备注，非必传
 */
@property (nonatomic, copy, nullable) NSString* memo;

@end


/**
 钱包转账/支付
 */
@interface MBRWWallet (Transaction)

/**
 支付：密码验证方式
 
 @param param 参数
 @param pwd 密码
 @param success 支付成功回调
 @param failure 支付失败回调
 */
+ (void)payWithPrarm:(MBRWPayParam*)param
            password:(NSString*)pwd
             success:(MBRWTransactionSuccessBlock)success
             failure:(MBRWFailureBlock)failure;

/**
 支付:
 enableTouchId==YES时，通过touchID验证，否则通过密码验证
 
 @param param 参数
 @param pwd 密码，enableTouchId==NO时有效
 @param enableTouchId 是否启动touchuID验证
 @param success 支付成功回调
 @param failure 支付失败回调
 */
+ (void)payWithPrarm:(MBRWPayParam*)param
            password:(NSString*)pwd
       enableTouchId:(BOOL)enableTouchId
             success:(MBRWTransactionSuccessBlock)success
             failure:(MBRWFailureBlock)failure;

/**
 转账：密码验证方式
 
 @param param 参数
 @param pwd 密码
 @param success 支付成功回调
 @param failure 支付失败回调
 */
+ (void)transferWithPrarm:(MBRWTransferParam*)param
            password:(NSString*)pwd
             success:(MBRWTransactionSuccessBlock)success
             failure:(MBRWFailureBlock)failure;

/**
 转账
 enableTouchId==YES时，通过touchID验证，否则通过密码验证
 
 @param param 参数
 @param pwd 密码，enableTouchId==NO时有效
 @param enableTouchId 是否启动touchuID验证
 @param success 支付成功回调
 @param failure 支付失败回调
 */
+ (void)transferWithPrarm:(MBRWTransferParam*)param
            password:(NSString*)pwd
       enableTouchId:(BOOL)enableTouchId
             success:(MBRWTransactionSuccessBlock)success
             failure:(MBRWFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
