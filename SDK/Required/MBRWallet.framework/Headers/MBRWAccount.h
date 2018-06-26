//
//  MBRWAccount.h
//  HEROPay
//
//  Created by lfl on 2018/5/24.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBRWalletNetworking/MBRBgCoin.h>

/**
 钱包账户
 */
@interface MBRWAccount : NSObject {
    
    @private
    NSString* _accountName;
    NSString* _accountAddress;
    NSString* _mnemonic;
    NSString* _privateKeyHex;
    NSString* _privateKeyTouch;
    NSMutableArray<MBRBgCoin *>* _erc20List;
    BOOL _isDefault;
}

/**
 账户名称
 */
@property (nonatomic, copy, readonly) NSString* accountName;

/**
 账户地址
 */
@property (nonatomic, copy, readonly) NSString* accountAddress;


#pragma mark - 创建账户
/**
 新建账户
 @discussion 通过账户名创建一个新账户
 内部使用随机助记词创建Account
 
 @param name 账户名
 @param pwdS 账户加密密码
 @return MBRWAccount
 */
+ (instancetype)accountWithName:(NSString*)name pwdSumary:(NSString*)pwdS;

/**
 助记词创建账户
 @discussion 通过账户名和助记词创建账户
 
 @param mnemonic 助记词
 @param name 账户名
 @param pwdS 账户加密密码
 @return MBRWAccount
 */
+ (instancetype)accountWithMnemonic:(NSString*)mnemonic name:(NSString*)name pwdSumary:(NSString*)pwdS;

/**
 keystory创建账户
 @discussion 通过账户名和keystory创建账户

 @param keyStore keystore文本
 @param pwdKS keystore密码
 @param name 账户名
 @param pwdS 账户加密密码
 @param callback 结果回调
 */
+ (void)accountWithKeystore:(NSString*)keyStore
                      pwdKS:(NSString*)pwdKS
                       name:(NSString*)name
                  pwdSumary:(NSString*)pwdS
                   callback: (void (^)(MBRWAccount *account, NSError *NSError))callback;

#pragma mark - 币操作
/**
 获取币列表

 @return 币数组
 */
- (NSArray<MBRBgCoin*> *)getCoinList;

/**
 获取/查找币

 @param coinId 币id/地址
 @return MBRBgCoin
 */
- (MBRBgCoin*)getCoinWithId:(NSString*)coinId;

/**
 获取eth类型的币
 
 @return 币
 */
- (MBRBgCoin *)getEthereumCoin;

@end
