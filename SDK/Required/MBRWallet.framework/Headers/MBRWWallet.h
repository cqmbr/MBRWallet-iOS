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
 */
typedef void(^MBRWAccountOprationSuccessBlock)(MBRWAccount *account);

/**
 *    操作失败回调
 *    失败错误码通过：NSError+MBRWHelper中mbrw_errorCode方法获得
      钱包定义的错误码参看类：MBRWErrorCode
 *    @param error 失败信息
 */
typedef void(^MBRWFailureBlock)(NSError *error);

/**
 账户钱包类
 */
@interface MBRWWallet : NSObject

/**
 设置初始化配置
 
 @param config 环境配置
 */
+ (void)setupWithConfig:(MBRWWalletConfig*)config;

/**
 同步账户余额信息
 
 @param complete 完成
 */
+ (void)syncAllAccountBalance:(void(^)(BOOL success))complete;

/**
 更新账户中币的选中状态
 
 @param coin MBRBgCoin
 @param address 账户地址
 @param callBack 完成
 */
+ (void)updateAccountCoinSelectSatate:(MBRBgCoin *)coin
                     toAccountAddress:(NSString *)address
                             callBack:(void (^)(BOOL success))callBack;

+ (NSString*)defaultEth;
+ (NSString*)maxEth;
+ (NSString*)minEth;

@end

#pragma mark - 账户相关
@interface MBRWWallet(Account)

/**
 创建一个新账户并添加到钱包

 @param name 账户名称
 @param pwd 交易密码
 @param success 操作成功
 @param failure 操作失败
 */
+ (void)addNewAccountWithName:(NSString*)name
                          pwd:(NSString *)pwd
                      success:(MBRWAccountOprationSuccessBlock)success
                      failure:(MBRWFailureBlock)failure;

/**
 助记词导入账户

 @param mnemonic 助记词
 @param pwd 交易密码
 @param name 账户名称
 @param success 操作成功
 @param failure 操作失败
 */
+ (void)importAccountByMnemonic:(NSString*)mnemonic
                            pwd:(NSString*)pwd
                           name:(NSString*)name
                        success:(MBRWAccountOprationSuccessBlock)success
                        failure:(MBRWFailureBlock)failure;

/**
 keystore导入账户

 @param keyStore keystore
 @param pwd 交易密码
 @param pwdKS keystore密码
 @param name 账户名称
 @param success 操作成功
 @param failure 操作失败
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
 @param pwd 校验密码
 @param success 操作成功
 @param failure 操作失败
 */
+ (void)removeAccount:(NSString*)name
                  pwd:(NSString*)pwd
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;

/**
 获取某账户的助记词

 @param address 账户地址
 @param pwd 密码
 @param err NSError
 @return 助记词文本
 */
+ (NSString*)getMnemonic:(NSString*)address
                pwd:(NSString*)pwd
              error:(NSError *__autoreleasing *)err;

/**
 账户是否已备份过
 
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
 @param success 导出成功
 @param failure 导出失败
 */
+ (void)exportKeystore:(NSString*)address
                   pwd:(NSString*)pwd
                 ksPwd:(NSString*)ksPwd
               success:(void (^)(NSString *json))success
               failure:(MBRWFailureBlock)failure;

/**
 设为默认账户

 @param address address
 @param pwd pwd
 @param success 操作成功
 @param failure 操作失败
 */
+ (void)setAsDefaultAccount:(NSString*)address
                  pwd:(NSString*)pwd
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;

/**
 重命名账户

 @param name 账户名
 @param newName 新名称
 @param pwd 交易密码
 @param success 操作成功
 @param failure 操作失败
 */
+ (void)renameAccount:(NSString*)name
              newName:(NSString*)newName
                        pwd:(NSString*)pwd
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

@end

#pragma mark - 币列表
/**
 钱包币列表辅助类
 */
@interface MBRWWallet(Coin)

/**
 同步币列表数据
 
 @param callBack 结果
 */
+ (void)syncAllERC20CoinList:(void (^)(BOOL success))callBack;

/**
 获取支持的所有币列表
 等价于getNomalCoins+getForceCoins
 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getAllCoins;

/**
 获取支持的非必须币列表

 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getNomalCoins;

/**
 获取支持的需强制添加到账户的币列表

 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getForceCoins;

@end

#pragma mark - Passward
/**
 钱包密码辅助类
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
 @param success 修改成功
 @param failure 修改失败
 */
+ (void)modifyPasswordWithOldPwd:(NSString *)oldPwd
                         newPwd:(NSString*)newPwd
                        success:(void (^)(void))success
                        failure:(MBRWFailureBlock)failure;

/**
 检查是否已设置过交易密码
 
 @return BOOL
 */
+ (BOOL)haveSetPassword;

/**
 判断密码是否相同
 
 @return BOOL
 */
+ (BOOL)isSamePassword:(NSString*)pwd;

/**
 设置密码提示

 @param hint 提示文本
 */
+ (void)setPasswardHint:(NSString*)hint;

/**
 获取密码提示文本

 @return 提示文本
 */
+ (NSString*)getPasswordHint;

@end

/**
 钱包环境配置类
 */
@interface MBRWWalletConfig : NSObject

/**
 默认：zh_CN
 */
@property (nonatomic, copy, nullable) NSString* languageCode;

/**
 渠道号(必须)
 */
@property (nonatomic, copy, nonnull) NSString* channel;

/**
 pushId
 */
@property (nonatomic, copy, nullable) NSString* jPushId;

/**
 主机域名(必须）
 */
@property (nonatomic, copy, nonnull) NSString* apiHost;

@end

