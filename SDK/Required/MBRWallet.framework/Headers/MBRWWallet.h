//
//  MBRWWallet.h
//  HEROPay
//
//  Created by lfl on 2018/5/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBRWAccount.h"
#import "NSError+MBRWHelper.h"

@class MBRWWalletConfig;

/**
 账户操作成功回调

 @param account MBRWAccount
 * 操作成功后返回的账户
 */
typedef void(^MBRWAccountOprationSuccessBlock)(MBRWAccount *account);

/**
 *    操作失败回调
 * @discussion 失败错误码通过：NSError+MBRWHelper中mbrw_errorCode方法获得
 *     钱包定义的错误码参看类：MBRWErrorCode
 * @param error 失败信息
 */
typedef void(^MBRWFailureBlock)(NSError *error);

/**
 * @abstract 账户钱包类
 * @discussion 提供主要功能包括：
 * - 提供账户操作
 * - 提供币操作
 * - 密码管理
 * - 同步余额、同步币列表
 */
@interface MBRWWallet : NSObject

/**
 设置初始化配置
 
 @param config 环境配置
 */
+ (void)setupWithConfig:(MBRWWalletConfig*)config;

/**
 获取当前钱包配置
 */
+ (MBRWWalletConfig *)getCurrentConfig;

/**
 设置当前钱包

 @param wId 钱包id
 @param err 错误信息
 */
+ (void)setCurrentWalletWithId:(NSString*)wId error:(NSError *__autoreleasing *)err;

/**
 清空当前钱包数据

 @param err 错误信息
 */
+ (void)clearCurrentWalletWithError:(NSError *__autoreleasing *)err;

/**
 同步账户余额信息
 
 @param complete 同步完成回调
 */
+ (void)syncAllAccountBalance:(void(^)(BOOL success))complete;

/**
 更新账户中币的选中状态
 
 @param coin MBRBgCoin
 @param address 账户地址
 @param callBack 完成回调
 */
+ (void)updateAccountCoinSelectSatate:(MBRBgCoin *)coin
                     toAccountAddress:(NSString *)address
                             callBack:(void (^)(BOOL success))callBack;

/**
 矿工费默认值
 
 @param coinId 币Id
 @return 价格（转换后的价格：单位：eth)
 */
+ (NSDecimalNumber*)defaultEthWithCoinId:(NSString*)coinId;

/**
 矿工费最大值
 
 @param coinId 币Id
 @return 价格（转换后的价格：单位：eth)
 */
+ (NSDecimalNumber*)maxEthWithCoinId:(NSString*)coinId;

/**
 矿工费最小值
 
 @param coinId 币Id
 @return 价格（转换后的价格：单位：eth)
 */
+ (NSDecimalNumber*)minEthWithCoinId:(NSString*)coinId;

@end

#pragma mark - 账户相关
@interface MBRWWallet(Account)

/**
 创建新账户

 @param name 账户名称
 @param pwd 交易
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)addNewAccountWithName:(NSString*)name
                          pwd:(NSString *)pwd
                      success:(MBRWAccountOprationSuccessBlock)success
                      failure:(MBRWFailureBlock)failure;

/**
 助记词导入账户

 @param mnemonic 助记词
 @param pwd 交易
 @param name 账户名称
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)importAccountByMnemonic:(NSString*)mnemonic
                            pwd:(NSString*)pwd
                           name:(NSString*)name
                        success:(MBRWAccountOprationSuccessBlock)success
                        failure:(MBRWFailureBlock)failure;

/**
 keystore导入账户

 @param keyStore keystore
 @param pwd 密码
 @param pwdKS keystore密码
 @param name 账户名称
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)importAccountByKeystore:(NSString*)keyStore
                            pwd:(NSString*)pwd
                          pwdKS:(NSString*)pwdKS
                           name:(NSString*)name
                        success:(MBRWAccountOprationSuccessBlock)success
                        failure:(MBRWFailureBlock)failure;

/**
 删除账户

 @param name 账户名
 @param pwd 密码
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)removeAccount:(NSString*)name
                  pwd:(NSString*)pwd
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;

/**
 获取账户助记词

 @param address 账户地址
 @param pwd 密码
 @param err 错误
 @return 助记词文本
 */
+ (NSString*)getMnemonic:(NSString*)address
                pwd:(NSString*)pwd
              error:(NSError *__autoreleasing *)err;

/**
 是否已备份账户
 
 @param address 账户地址
 @return YES：账户已经备份过助记词或者账户是由keystore导入的
 */
+ (BOOL)isAccountBackup:(NSString*)address;

/**
 备份账户
 
 @param address 账户地址
 @param pwd 校验密码
 @param mnemonic 校验助记词
 @param success 操作成功
 @param failure 操作失败
 */
+ (void)backupAccount:(NSString*)address
                  pwd:(NSString*)pwd
             mnemonic:(NSString*)mnemonic
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;

/**
 导出keystore
 
 @param address 账户地址
 @param pwd 账户密码
 @param ksPwd keystory密码
 @param success 导出成功回调
 @param failure 导出失败回调
 */
+ (void)exportKeystore:(NSString*)address
                   pwd:(NSString*)pwd
                 ksPwd:(NSString*)ksPwd
               success:(void (^)(NSString *json))success
               failure:(MBRWFailureBlock)failure;

/**
 设为默认账户

 @param address 地址
 @param pwd 密码
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)setAsDefaultAccount:(NSString*)address
                  pwd:(NSString*)pwd
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;

/**
 设为默认账户
 
 @param address address
 @param success 操作成功
 @param failure 操作失败
 */
+ (void)setAsDefaultAccount:(NSString*)address
                    success:(MBRWAccountOprationSuccessBlock)success
                    failure:(MBRWFailureBlock)failure;

/**
 重命名账户

 @param name 账户名
 @param newName 新名称
 @param pwd 交易密码
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)renameAccount:(NSString*)name
              newName:(NSString*)newName
                        pwd:(NSString*)pwd
                    success:(MBRWAccountOprationSuccessBlock)success
                    failure:(MBRWFailureBlock)failure;

/**
 重命名账户
 
 @param name 账户名
 @param newName 新名称
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)renameAccount:(NSString*)name
              newName:(NSString*)newName
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;

/**
 获取所有账户

 @return MBRWAccount数组
 */
+ (NSArray<MBRWAccount*>*)getAllAccount;

/**
 获取默认账户

 @return MBRWAccount
 */
+ (MBRWAccount*)getDefaultAccount;

/**
 查找账户
 
 @param address 地址
 @return MBRWAccount
 */
+ (MBRWAccount*)getAccountWithAddress:(NSString*)address;

/**
 查找账户
 
 @param name 名称
 @return MBRWAccount
 */
+ (MBRWAccount*)getAccountWithName:(NSString*)name;

@end

#pragma mark - 钱包币列表辅助类
/**
 钱包币列表辅助类
 * @discussion 提供币管理功能:
 * - 同步币列表
 * - 获取币列表
 */
@interface MBRWWallet(Coin)

/**
 同步币列表
 
 @param callBack 结果回调
 * - success=YES:同步成功
 */
+ (void)syncAllERC20CoinList:(void (^)(BOOL success))callBack;

/**
 获取所有币列表
 
 * @discussion 等价于getNomalCoins+getForceCoins
 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getAllCoins;

/**
 获取非必选币列表

 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getNomalCoins;

/**
 获取必选币列表

 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getForceCoins;

/**
 通过id获取币
 
 @param coinId 币id
 @return 币
 */
+ (MBRBgCoin *)getCoinById:(NSString *)coinId;

/**
 获取ETH货币
 
 @return ETH币
 */
+ (MBRBgCoin *)getEthCoin;

/**
 通过tokenAddress获取币
 
 @param tokenAddress 币的合约地址
 @return 币
 */
+ (MBRBgCoin *)getCoinByTokenAddress:(NSString *)tokenAddress;

@end

#pragma mark - 钱包密码辅助类
/**
 钱包密码辅助类
 * @discussion 提供钱包密码管理功能，主要有：
 * - 设置密码
 * - 修改密码
 * - 校验密码是否已设置，密码是否一致
 */
@interface MBRWWallet(Passward)

/**
 设置交易密码

 @param pwd 密码
 @param err 错误
 */
+ (void)setPassword:(NSString*)pwd error:(NSError *__autoreleasing *)err;

/**
 修改密码

 @param oldPwd 旧密码
 @param newPwd 新密码
 @param success 修改成功回调
 @param failure 修改失败回调
 */
+ (void)modifyPasswordWithOldPwd:(NSString *)oldPwd
                         newPwd:(NSString*)newPwd
                        success:(void (^)(void))success
                        failure:(MBRWFailureBlock)failure;

/**
 是否已设置密码
 
 * @discussion 校验是否设置过密码
 * - 使用账户操作等需要密码权限校验的接口前应该先设置密码
 * - 设置密码接口调用：[MBRWWallet setPassword:pwd error:&error];
 @return YES=已设置；NO=未设置
 */
+ (BOOL)haveSetPassword;

/**
 密码是否相同
 
 * @discussion 校验传入密码是否与设置的密码相等
 @return YES = 相等；NO = 不相等
 */
+ (BOOL)isSamePassword:(NSString*)pwd;

/**
 设置密码提示

 @param hint 密码提示文本
 */
+ (void)setPasswardHint:(NSString*)hint;

/**
 获取密码提示

 @return 密码提示文本
 */
+ (NSString*)getPasswordHint;

@end


/**
 钱包使用模式

 - MBRWWalletModel_Single: 但钱包模式
 - MBRWWalletModel_Muti: 多钱包模式
 */
typedef NS_ENUM(NSInteger, MBRWWalletModel) {
    MBRWWalletModel_Single = 0,
    MBRWWalletModel_Muti
};

#pragma mark - 钱包配置类
/**
 * @abstract 钱包环境配置类
 * @discussion 使用钱包提供功能前需要设置配置
 * - 设置方式：[MBRWWallet setupWithConfig:config];
 */
@interface MBRWWalletConfig : NSObject

/**
 * @abstract 钱包模式
 * @discussion 必选 MBRWWalletModel
 */
@property (nonatomic, assign) MBRWWalletModel walletMode;

/**
 * @abstract 语言码
 * @discussion 可选 默认值：zh_CN
 */
@property (nonatomic, copy, nullable) NSString* languageCode;

/**
 * @abstract 渠道号
 * @discussion 必填
 */
@property (nonatomic, copy, nonnull) NSString* channel;

/**
 * @abstract 私钥(平台分配)
 * @discussion 必填
 */
@property (nonatomic, copy, nonnull) NSString* privateKey;

/**
 * @abstract 商户id(平台分配)
 * @discussion 必填
 */
@property (nonatomic, copy, nonnull) NSString* merchantId;


/**
 * @abstract 推送Id
 * @discussion 可选
 */
@property (nonatomic, copy, nullable) NSString* jPushId;

/**
 * @abstract 服务端主机域名
 * @discussion 可选
 */
@property (nonatomic, copy, nonnull) NSString* apiHost;

@end

