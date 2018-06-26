//
//  MBRWWallet+Transaction.h
//  MBRWallet
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
 转账参数类
 */
@interface MBRWTransferParam:NSObject

/**
 币ID
 * @discussion 转账使用的币Id 必须
 */
@property (nonatomic, copy) NSString* coinId;
/**
 币
 * @discussion 转账使用的币 非必须。不传时通过coinId内部查找对应的币
 */
@property (nonatomic, strong, nullable) MBRBgCoin* coin;


/**
 转出账户地址
 * @discussion 必须
 */
@property (nonatomic, copy) NSString* addressFrom;

/**
 转入账户
 * @discussion 必须
 */
@property (nonatomic, copy) NSString* addressTo;

/**
 转出币数量
 * @discussion 必须
 */
@property (nonatomic, copy) NSString* amountStr;

/**
  矿工费
 * @discussion 必须
 */
@property (nonatomic, copy) NSString* feeStr;

/**
 备注
 * @discussion 非必须
 */
@property (nonatomic, copy, nullable) NSString* memo;

@end

/**
 支付参数类
 */
@interface MBRWPayParam:NSObject

/**
 订单信息
 * @discussion 必须。订单信息
 */
@property (nonatomic, copy) NSString* orderInfo;
/**
 订单数据
 * @discussion 非必须。不填时通过orderInfo转换出订单字典
 */
@property (nonatomic, strong, nullable) NSDictionary* orderDic;

/**
 转出账户地址
 * @discussion 必须
 */
@property (nonatomic, copy) NSString* addressFrom;

/**
 矿工费
 * @discussion 必须
 */
@property (nonatomic, copy) NSString* feeStr;

/**
 备注
 * @discussion 非必传
 */
@property (nonatomic, copy, nullable) NSString* memo;

@end


/**
 钱包转账/支付
 */
@interface MBRWWallet (Transaction)

/**
 密码方式支付
 @discussion 密码验证方式
 
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
 支付
 @discussion
 - enableTouchId==YES时，通过touchID验证，否则通过密码验证
 - 建议使用密码支付接口
 
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
 密码方式转账
 
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
 @discussion
 - enableTouchId==YES时，通过touchID验证，否则通过密码验证
 - 建议使用密码方式转账
 
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
